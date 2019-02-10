const express = require('express');
const https = require('https');
const MessagingResponse = require('twilio').twiml.MessagingResponse;
const app = express();
const port = 3000;

import {REGION, ENDPOINT, TABLE_NAME} from 'vars';

var bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({extended: false}));

var AWS = require('aws-sdk');
AWS.config.update({
    region: REGION,
    endpoint: ENDPOINT
});

db = new AWS.DynamoDB();

app.get('/', (req,res) => res.send('Hackerino'));

app.get('/buildings/:bldgName/', function (req, res){
    let bldgName = req.params['bldgName'];
    res.setHeader('Content-Type', 'application/json');
    let electricity = getUsage(bldgName, '\\Electricity|Demand_kBtu');
    let chilledWater = getUsage(bldgName, '\\ChilledWater|Demand_kBtu');
    let steam = getUsage(bldgName, '\\Steam|Demand_kBtu');
    let total = getUsage(bldgName, '|Total Demand');

    Promise.all([electricity, chilledWater, steam, total]).then(function(values){
        let result = {
            "Electricity":values[0],
            "ChilledWater":values[1],
            "Steam":values[2],
            "Total":values[3]
        };
        res.send(JSON.stringify(result));
    }, function(err){
        console.log(err);
    });
});

app.post('/sms/', function(req, res){
    let params = {
        ExpressionAttributeValues: {
            ':v1':{
                S: req.body.From
            }
        },
        KeyConditionExpression: 'phone_number = :v1',
        IndexName:'phone_numbers',
        TableName: TABLE_NAME
    }

    db.query(params, function(err, qData) {
        if (err) {
            console.log(err, err.stack);
        } else if(qData.Count > 0){
            let msg = toTitleCase(req.body.Body);
            const twiml = new MessagingResponse();
            let data = getUsage(msg, '|Total Demand');
            data.then(function(result){
                if(result != undefined){
                    twiml.message(msg + ': ' + result + ' kBtu');
                } else {
                    twiml.message(msg + ': Invalid Building');
                }
                res.writeHead(200, {'Content-Type': 'text/xml'});
                res.end(twiml.toString());
            });
        }
    });
});

app.post('/', (req, res) => req.send('Received POST request'));

app.listen(port, () => console.log('Listening on port ' + port));

function getUsage(bldgName, param){
    return new Promise(function(resolve, reject){
        https.get('https://ucd-pi-iis.ou.ad3.ucdavis.edu/piwebapi/attributes?path=\\\\UTIL-AF\\CEFS\\UCDAVIS\\Buildings\\' + bldgName + param + '&selectedFields=webId', (resp) => {
            let data = '';
        
            resp.on('data', (chunk) => {
                data += chunk;
            });

            resp.on('end', () => {
                let webID = JSON.parse(data).WebId;
                let value = getValue(webID);
                value.then(function(result){
                    resolve(result);
                }, function(err){
                    reject(err);
                });
            });

            resp.on('error', (err) => {
                reject(err);
            });
        });
    });
}

function getValue(webID){
    return new Promise(function(resolve, reject){
        https.get('https://ucd-pi-iis.ou.ad3.ucdavis.edu/piwebapi/streams/' + webID + '/value?selectedField=Value', (resp) => {
            let data = '';
        
            resp.on('data', (chunk) => {
                data += chunk;
            });

            resp.on('end', () => {
                let value = JSON.parse(data).Value;
                resolve(value);
            });

            resp.on('error', (err) => {
                reject(err);
            });
        });
    });
}

function toTitleCase(str) {
    return str.replace(
        /\w\S*/g,
        function(txt) {
            return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
        }
    );
}