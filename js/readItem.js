// Note - boilerplate template code for accessing DynamoDB service copied and
// adapted from AWS documentation - available at following URL:
//
// https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/GettingStarted.Js.03.html

// Additional template code for connecting various AWS services (Cognito,
// API Gateway, Lambda, and DynamoDB) used from AWS Serverless 'Getting-Started'
// guide which can be accessed at the following URL:
//
// https://aws.amazon.com/getting-started/hands-on/build-serverless-web-app-lambda-apigateway-s3-dynamodb-cognito/

const AWS = require('aws-sdk');
var docClient = new AWS.DynamoDB.DocumentClient();

exports.handler = (event, context, callback) => {
    //if (!event.requestContext.authorizer) {
      //errorResponse('Authorization not configured', context.awsRequestId, callback);
      //return;
    //}

    // Because we're using a Cognito User Pools authorizer, all of the claims
    // included in the authentication token are provided in the request context.
    // This includes the username as well as other attributes.
    //const username = event.requestContext.authorizer.claims['cognito:username'];

    // The body field of the event in a proxy integration is a raw string.
    // In order to extract meaningful values, we need to first parse this string
    // into an object. A more robust implementation might inspect the Content-Type
    // header first and use a different parsing strategy based on that value.
    //const requestBody = JSON.parse(event.body);
    var runId = "123456";
    return readItem(runId);
};

function readItem(runId) {
    return docClient.get({
        TableName: 'Runs',
        Key: {
          RunId: runId 
        }, 
        AttributesToGet: [
            'RunId',
            'Date',
            'Distance',
            'Location',
            'Notes'
        ],
    }).promise();
};

