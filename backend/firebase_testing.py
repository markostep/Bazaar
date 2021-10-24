from firebase_admin import credentials, initialize_app, db
from warnings import warn
import api_testing as api
from inspect import currentframe, getouterframes
from datetime import datetime, timedelta
import math


cred = credentials.Certificate("./bazaar-96e54-firebase-adminsdk-zac07-5bfa8beefa.json")
default_app = initialize_app(cred, {'databaseURL': 'https://bazaar-96e54-default-rtdb.firebaseio.com/'})

head = db.reference('/')
stores = db.reference('/Stores/')
users = db.reference('/Users/')
posts = db.reference('/Posts/')
full_bar = 1000

# the fields that must be in every store
store_fields = {'Classification', 'Industry', 'Location', 'Name', 'Image', 'Link'}
purchase_fields = {'description', 'orderId', 'price', 'productId', 'productName', 'productType', 'quantity', 'retailer'}


def check_data(func):
    def wrapper(*args, **kwargs):
        ref = kwargs['ref'] if 'ref' in kwargs else args[1]
        data = kwargs['data'] if 'data' in kwargs else args[0]

        if getouterframes(currentframe(), 2)[1][3] == 'add_order':
            check = purchase_fields
        elif ref is stores:
            check = store_fields
        else:
            check = []

        for name, info in data.items():
            if ref is stores:
                data[name]['Name'] = name

            for field in check:
                if field not in info:
                    warn(f'NO {field} WAS GIVEN -- FILLED IN NULL')
                    data[name][field] = "NULL"
        return func(*args, **kwargs)
    return wrapper

@check_data
def overwrite(data, ref=head):
    '''
    Overwrites database at given reference with given data
    '''
    ref.set(data)

def get(ref=head, sort_by=None):
    '''
    Returns the database's contents at the given reference
    If key is not None, then orders contents by key
    '''
    if sort_by is None:
        return ref.get()
    else:
        return ref.order_by_child(sort_by).get()

def getUserIds():
    return set(get(ref=users).keys())

def getStores():
    return set(get(ref=stores).keys())

@check_data
def add(data, ref=head):
    '''
    Adds data to database at given reference
    NOTE: using an existing key will overwrite that existing data
    '''
    for name,info in data.items():
        ref.child(name).set(info)

def add_order(orderId):
    customerId, products = api.parse_order(api_order(orderId, 'GET'))
    if customerId in getUserIds():
        for prodId,prodInfo in products.items():
            add({prodId: prodInfo}, ref=db.reference(f'/Users/{customerId}/Purchases/'))
    else:
        warn(f'CUSTOMER "{customerId}" DOES NOT EXIST -- ORDER {orderId} NOT ADDED')

def update(key, mapping, ref=head):
    '''
    Updates values at key with the given mapping
    '''
    ref.child(key).update(mapping)

def remove(key, ref=head):
    '''
    Removes key at the given reference
    '''
    ref.child(key).set({})

def api_order(input, method, debug=False):
    if method == 'POST':
        # for each purchase:
        ##  modifierCode contains 'E' if enviornmentally friendly
        ##  extendedAmount is the score of the order (number of attributes it checks off)
        if not debug:
            start = datetime.now()
            time = start

            while time <= start:
                code = get(db.reference('/Scanned/'))
                time =  datetime.strptime(code['Time'], '%Y/%m/%d %H:%M:%S')

            input['customer'] = {'id': code['ID']}

        allStores = get(stores)
        points = 1
        num_env, num_clothes = 0,0

        attrs = (allStores[input['owner']]['Classification'] if input['owner'] in allStores else '')

        for prod in input['orderLines']:
            if 'E' in prod['modifierCode']: num_env += 1
            if prod['itemType'] == 'Clothes': num_clothes += 1

            prod_attrs = attrs + prod['modifierCode']
            score = len(prod_attrs)
            prod_points = prod['unitPrice']*math.log(score + 1)

            points += prod_points
            prod['extendedAmount'] = prod_points
            prod['priceModifiers'] = [{}]
            prod['priceModifiers'][0]['amount'] = score
            prod['priceModifiers'][0]['description'] = prod_attrs

        userId = input['customer']['id']
        user = get(users)[userId]
        if 'Points' in user: points += user['Points']


        points += check_posted(userId)
        update(userId, {'Points': points}, users)
        update_badges(userId, num_env, num_clothes)
        reorder_posts()

    return api.api_order(input, method)


def update_badges(userId, num_env, num_clothes):
    '''
    Updates the user's progress towards each of the badges
    '''
    user = get(users)[userId]
    points = user['Points']

    if 'Badges' in user:
        num_clothes += user['Badges']['clothes_collector']['num_clothes_purchases']
        num_env += user['Badges']['planet_saver']['num_env_purchases']

    update('Badges', {
                'tree_hugger': {'achieved': num_env >= 1},
                'stronger_together': {'achieved': points >= full_bar},
                'planet_saver': {'achieved': num_env >= 5, 'num_env_purchases': num_env},
                'clothes_collector': {'achieved': num_clothes >= 10, 'num_clothes_purchases': num_clothes},
                'best_friends': {'achieved': len(user['Friends'] if 'Friends' in user else []) >= 5},
                'going_bazaar': {'achieved': points >= full_bar*10}
            }, db.reference(f'/Users/{userId}/'))

def check_posted(userId):
    '''
    Returns bonus points for when users post about their purchases
    '''
    user = get(users)[userId]
    bonus = 0

    if 'Purchases' in user:
        for purchase_id,purchase in user['Purchases'].items():
            if purchase['posted'] and not purchase['doubled']:
                bonus += purchase['points']
                update(purchase_id, {'doubled': True}, db.reference(f'/Users/{userId}/Purchases/'))

    return bonus

def reorder_posts():
    '''
    Updates the order of the posts in the database
    '''
    allPosts = get(db.reference('/Posts/'))
    for postId,info in allPosts.items():
        update(postId,
               {'postRanking': 1 / (info['likes']/5 + \
                               max(10 - (datetime.now() - datetime.strptime(info['time'], '%Y/%m/%d %H:%M:%S'))/timedelta(days=1), 0) + \
                               info['score']*2.5)
                }, posts)




# data = {
#     'Beautiful Restaurant': {
#         'Classification': '??',
#         'Industry': 'Restaurant',
#         'Location': 'Atlanta'
#     }
# }


# update('Solar Nails', {'Classification': 'Minority-'}, stores)
# update('Stores/Solar Nails', {'Classification': 'Minority-owned'}, head)

# add({}, stores)

# print(get(stores))

# print(get(stores, "Name"))

# remove('Beautiful Restaurant', stores)




# for k,v in orderDetails.items():
#     print(f'{k}: {v}')


# print(api_order('12601857220537095966'))
# add_order('12940712621800496162')
# add_order('11669656148723416957')


debug = True
test_dict = {
    'comments': 'APEX Museum: Bed sheets, Stuffed Animal',
    'orderLines': [
        {
            'description': 'Rainbow Bed sheets with Silk linen tops and Tao\'s comforter mattress',
            'itemType': 'House',
            'productId': {'value': 'Rainbow bed sheets'},
            'quantity': {'value': 2},
            'unitPrice': 0,
            'modifierCode': 'E'
        },
        {
            'description': 'Bat Stuffed Animal',
            'itemType': 'Kids',
            'productId': {'value': 'Bat Stuffed Animal 5ft x 2ft'},
            'quantity': {'value': 1},
            'unitPrice': 0,
            'modifierCode': ''
        }
    ],
    'owner': 'APEX Museum',
    # 'payments': [{'amount': 43.50,}],
}

if debug: test_dict['customer'] = {'id': '0kKmboE80YhrRUS5YCb3J4OjD802'}


# print(api_order(test_dict, 'POST'))
# print(api_order('13139740844105295507', 'GET')['comments'])
# add_order(api_order(test_dict, 'POST', debug=debug))
# api.parse_order(api_order('12145144029130432348', 'GET'))
# update_badges('0kKmboE80YhrRUS5YCb3J4OjD802', 1, 5)

# print(type(get(users)['0kKmboE80YhrRUS5YCb3J4OjD802']['Purchases']['764395a1c1dc4b51855610dd615b32cd']['posted']))
# print(check_posted('0kKmboE80YhrRUS5YCb3J4OjD802'))

# reorder_posts()
# print(get(posts, 'postRanking').keys())




