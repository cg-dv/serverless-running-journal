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

exports.handler = (event, context) => {
    writeItem(); 
}

function writeItem() {
    var params = {
        TableName :"Runs",
        Item:{
            "RunID": "1234",
            "Date": "Sept-5-2021",
            "Distance": 4,
            "Location": "Central Park",
            "Notes": "Test Item"
        }
    };
    docClient.put(params, function(err, data) {
        if (err) {
            return err 
        } else {
            return "\n" + JSON.stringify(data, undefined, 2)
        }
    });
}

