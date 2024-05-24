import boto3
client = boto3.client('dynamodb')

def lambda_handler(event, context):
    get = client.get_item(
        TableName='visits_table',
        Key={
            'id': {
                'S': '1',
            }
        }
    )

    visits_count = get['Item']['visits_count']['N']
    visits_count = int(visits_count) + 1

    print(visits_count)

    put = client.put_item(
        TableName='visits_table',
        Item={
            'id': {
                'S': '1'
            },
            'visits_count': {
                'N': str(visits_count)
            }
        }
    )
    
    return visits_count
