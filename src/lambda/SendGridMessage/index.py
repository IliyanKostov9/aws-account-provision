import logging
import json


logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)


def handler(event, context):

    logger.info("Hello world")
    logger.info(event)

    return {
        "statusCode": 200,
        "body": json.dumps(event),
        "headers": {
            "Content-Type": "application/JSON",
            "Access-Control-Allow-Origin": "*",
        },
    }
