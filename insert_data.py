from __future__ import print_function
from boto3 import resource
import csv


class DynamoRepository:
    def __init__(self, target_dynamo_table, region='us-east-2'):
        self.dynamodb = resource(service_name='dynamodb', region_name=region)
        self.target_dynamo_table = target_dynamo_table
        self.table = self.dynamodb.Table(self.target_dynamo_table)

    def update_dynamo_event_counter(self, event_name, event_datetime, event_count=1):
        response = self.table.update_item(
            Key={
                'EventId': str(event_name),
                'EventDay': int(event_datetime)
            },
            ExpressionAttributeValues={":eventCount": int(event_count)},
            UpdateExpression="ADD EventCount :eventCount")
        return response


def main():
    # uncomment for manual Dynamo setup
    # table_name = 'user-visits'

    # uncomment for SAM deployment
    table_name = 'user-visits-sam'
    input_data_path = 'dynamodb-sample-data.txt'
    iteration_number = 1

    items_to_add = []
    dynamo_repo = DynamoRepository(table_name)
    with open(input_data_path, 'r') as sample_file:
        csv_reader = csv.DictReader(sample_file)
        for row in csv_reader:
            items_to_add.append(row)

    for _ in range(iteration_number):
        for row in items_to_add:
            response = dynamo_repo.update_dynamo_event_counter(row['EventId'],
                                                              row['EventDay'],
                                                              row['EventCount'])
            print(response)


if __name__ == '__main__':
    main()