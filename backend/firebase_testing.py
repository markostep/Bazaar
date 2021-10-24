from firebase_admin import credentials, initialize_app, db
from warnings import warn
import api_testing as api
from inspect import currentframe, getouterframes
from datetime import datetime
import math


cred = credentials.Certificate("./bazaar-96e54-firebase-adminsdk-zac07-5bfa8beefa.json")
default_app = initialize_app(cred, {'databaseURL': 'https://bazaar-96e54-default-rtdb.firebaseio.com/'})

head = db.reference('/')
stores = db.reference('/Stores/')
users = db.reference('/Users/')

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

        attrs = (allStores[input['owner']]['Classification'] if input['owner'] in allStores else 0)

        for prod in input['orderLines']:
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

        update(userId, {'Points': points}, users)
        update_badges(userId)


    return api.api_order(input, method)

def update_badges(userId):
    '''
    Updates the user's progress towards each of the badges
    '''
    user = get(users)[userId]
    # allStores[input['owner']]['Classification'] if input['owner']


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
            'description': 'Magenta Bed sheets with Silk linen tops and Tao\'s comforter mattress',
            'itemType': 'House',
            'productId': {'value': 'Magenta bed sheets'},
            'quantity': {'value': 2},
            'unitPrice': 5.3,
            'modifierCode': 'E'
        },
        {
            'description': 'Fox Stuffed Animal',
            'itemType': 'Kids',
            'productId': {'value': 'Fox Stuffed Animal 5ft x 2ft'},
            'quantity': {'value': 1},
            'unitPrice': 3.5,
            'modifierCode': ''
        }
    ],
    'owner': 'APEX Museum',
    # 'payments': [{'amount': 43.50,}],
}

if debug: test_dict['customer'] = {'id': '0kKmboE80YhrRUS5YCb3J4OjD802'}


# print(api_order(test_dict, 'POST'))
# print(api_order('13139740844105295507', 'GET')['comments'])
add_order(api_order(test_dict, 'POST', debug=debug))
# api.parse_order(api_order('12145144029130432348', 'GET'))



# when adding purchases, automatically check db for that retailer to add the classification

