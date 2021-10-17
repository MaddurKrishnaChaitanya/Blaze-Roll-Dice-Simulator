import json, random, boto3
from random import randint
import uuid
from collections import Counter
from decimal import Decimal


def lambda_handler(event, context):
    # TODO implement
    client = boto3.resource('dynamodb')
    table = client.Table('ROLL_DICE_SIMULATION')
    print(event["queryStringParameters"])
    noofdice = int(event["queryStringParameters"]['noofdice'])
    sidesofdice = int(event["queryStringParameters"]['sidesofdice'])
    totalrolls = int(event["queryStringParameters"]['totalrolls'])
    i = 0
    simulation = {}
    for i in range(totalrolls):
        dice_sum = 0
        for j in range(noofdice):
            min_val = 1
            max_val = int(sidesofdice)
            dice_sum += random.randint(min_val, max_val)
        simulation['sum_{}'.format(i)] = dice_sum
        # simulation['itr_{}'.format(i)] = simulation

    simulation_res = Counter(simulation.values())
    countroll = json.loads(json.dumps(simulation_res), parse_int=Decimal)
    data = table.put_item(
        Item={
            'id': str(uuid.uuid4()),  # Unique identifier for each item
            'noofdice': (noofdice),
            'sidesofdice': (sidesofdice),
            'totalrolls': (totalrolls),
            'total_roll_times': countroll
        }
    )
    return {
        'statusCode': 200,
        'body': json.dumps({
            'noofdice': str(noofdice),
            'sidesofdice': str(sidesofdice),
            'totalrolls': str(totalrolls),
            'rolls': json.dumps(simulation_res)
        })
    }
