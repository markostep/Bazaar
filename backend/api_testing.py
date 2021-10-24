import requests
import http.client
import urllib
import datetime
import base64
import hmac
import hashlib
import json



def createHMAC(req, prepped, hmac_headers=[
                                            'content-type',
                                            'content-md5',
                                            'nep-application-key',
                                            'nep-correlation-id',
                                            'nep-organization',
                                            'nep-service-version',
                                            ],
                print_message=False, SHARED='6201704010394ef8a8d0770f823170f4', SECRET='d3648028cc1045ccb944d0ec359cce54',
                siteId='79b95b9f4fcd46c78415d4ae15f59467'):
    '''
    takes an unprepped and prepped request and creates the HMAC header for authorization
    '''

    toSign = prepped.method + "\n" + urllib.parse.urlsplit(prepped.url).path


    for header in req.headers.keys():
        if header in hmac_headers:
            toSign += '\n' + req.headers[header]

    key = bytes(SECRET + datetime.datetime.strptime(prepped.headers['date'], "%a, %d %b %Y %H:%M:%S %Z").strftime("%Y-%m-%dT%H:%M:%S.000Z"), 'utf-8')

    message = bytes(toSign, 'utf-8')
    if print_message: print('Message', message, end='\n\n')

    digest = hmac.new(key, msg=bytes(message), digestmod=hashlib.sha512).digest()
    signature = base64.b64encode(digest)
    return "AccessKey {}:{}".format(SHARED, signature.decode('ascii'))



def api_order(input, method, nepOrganization='test-drive-39a80ee8ccf647cca1c51', siteId='79b95b9f4fcd46c78415d4ae15f59467'):
    '''
    general interaction with API for get or post
    FOR GET: input is the order id --> returns the data at that ID as a dicitonary
    FOR POST: input is the data to post --> returns the order id
    '''

    if method != 'GET' and method != 'POST':
        raise TypeError('Method given was not GET or POST')

    if method == 'GET' and not isinstance(input, str):
        raise TypeError('Non-string input for GET')

    if method == 'POST':
        if not isinstance(input, dict):
            raise TypeError('Non-dictionary input for POST')


    get = method == 'GET'
    endpoint = f'/order/3/orders/1/{input}' if get else '/order/3/orders/1'
    url = f'https://gateway-staging.ncrcloud.com{endpoint}'

    headers = {
        'date': datetime.datetime.now(datetime.timezone.utc).strftime("%a, %d %b %Y %H:%M:%S %Z"),
        'accept': 'application/json',
        'content-type': 'application/json',
        'nep-organization': nepOrganization,
    }

    request = eval(f"requests.Request(method, url, headers=headers{'' if get else ', data=json.dumps(input)'})")
    prepped = request.prepare()
    s = requests.Session()
    prepped.headers['Authorization'] = createHMAC(request, prepped)
    res = s.send(prepped)

    if 'id' not in res.json(): print(res.json())
    return res.json() if get else res.json()['id']



def parse_order(order):
    '''
    Returns tuple of customer id and a list of dictionaries of relevant info for each product in the order
    '''

    products = {}

    orderInfo = {
        'orderId': order['id'],
        # 'customerID': order['customer']['id'], # this will instead be returning at index 0 of tuple
        # 'customerName': order['customer']['name'], # no longer needed
        'retailer': order['owner'],
        # 'payment': order['payments'][0]['amount'], # no longer needed
    }

    for product in order['orderLines']:
        # line ID assumed to be ID of the product
        # productId[value] assumed to be product name
        # modifierCode contains 'E' if enviornmentally friendly
        # priceModifiers contains the score of the product (number of attributes it checks off) and the applicable attributes
        # extendedAmount contains the score for that product

        products[product['lineId']] = {
            'productName': product['productId']['value'],
            'quantity': product['quantity']['value'],
            'description': product['description'],
            'productType': product['itemType'],
            'price': product['unitPrice'], # this is actually the total price we paid for this product (not per quantity)
            'productId': product['lineId'],
            'env_friendly': 'E' in product['modifierCode'],
            'score': product['priceModifiers'][0]['amount'],
            'attributes': product['priceModifiers'][0]['description'],
            'points': product['extendedAmount'],
            'posted': False,
            'doubled': False
        }

        for k,v in orderInfo.items():
            products[product['lineId']][k] = v


    return order['customer']['id'], products



if __name__ == '__main__':
    # test_dict = {
    #     'comments': 'IKEA order: Bed sheets, Teddy bear',
    #     'customer': {'id': 'Vm6gfWN9R4WrRHRJRswfGewkirx1'},
    #     'orderLines': [
    #         {
    #             'description': 'Neon Bed sheets with Silk linen tops and Tao\'s comforter mattress',
    #             'itemType': 'House',
    #             'productId': {'value': 'Neon bed sheets'},
    #             'quantity': {'value': 2},
    #             'unitPrice': 50.325
    #         },
    #         {
    #             'description': 'Dragon Stuffed Animal',
    #             'itemType': 'Kids',
    #             'productId': {'value': 'Dragon Stuffed Animal 5ft x 2ft'},
    #             'quantity': {'value': 1},
    #             'unitPrice': 39.50
    #         }
    #     ],
    #     'owner': 'IKEA',
    #     'payments': [{'amount': 43.50,}],
    # }

    print(api_order('10178637205797718132', 'GET'))
