import json, random, boto3
from boto3.dynamodb.conditions import Key, And, Attr
import decimal
import logging
import ast
from collections import OrderedDict, Counter
from itertools import groupby
from operator import itemgetter
import functools


def lambda_handler(event, context):
    totalrolls = 0
    totalsimulation = 0
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    if event["queryStringParameters"]:
        listIteams = []
        result = {}
        total_rolls = 0
        noofdice = int(event["queryStringParameters"]['noofdice'])
        sidesofdice = int(event["queryStringParameters"]['sidesofdice'])
        client = boto3.resource('dynamodb')
        table = client.Table('ROLL_DICE_SIMULATION')
        givencombination = table.scan(
            FilterExpression=Attr('noofdice').eq(noofdice) & Attr('sidesofdice').eq(sidesofdice))
        for item in givencombination['Items']:
            listIteams.append(item['total_roll_times'])
            total_rolls += item['totalrolls']
        if len(listIteams) > 0:
            result = {key: int(sum(e[key] for e in listIteams)) for key in listIteams[0].keys()}
        relative_distribution = {}
        for key, value in result.items():
            relative_distribution[key] = str(round(((value / total_rolls) * 100), 2)) + '%'
        return {
            'statusCode': 200,
            'body': json.dumps({
                "dicenumber - dice side": str(relative_distribution),
                # "total_rolls": str(total_rolls)
            })
        }

    else:
        # TODO implement
        client = boto3.resource('dynamodb')
        table = client.Table('ROLL_DICE_SIMULATION')
        # resp = table.scan(FilterExpression=Attr('noofdice').eq(noofdice) & Attr('sidesofdice').eq(sidesofdice))
        input_data = table.scan()
        grouper = itemgetter("noofdice", "sidesofdice")
        result = []
        for key, grp in groupby(sorted(input_data['Items'], key=grouper), grouper):
            temp_dict = dict(zip(["noofdice", "sidesofdice"], (key)))
            temp_list = [item["totalrolls"] for item in grp]
            temp_dict['noofdice'] = int(temp_dict['noofdice'])
            temp_dict['sidesofdice'] = int(temp_dict['sidesofdice'])
            temp_dict["total_rolls"] = int(sum(temp_list))
            temp_dict["total_simulation"] = int(len(temp_list))
            result.append(temp_dict)

        return {
            'statusCode': 200,
            'body': json.dumps({
                "dicenumber - dice side": str(result)
            })
        }
