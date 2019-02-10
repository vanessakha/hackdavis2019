# UC Davis Energy API
REST API that provides energy usage data for buildings on the UC Davis campus using the OSISoft dataset. Users can also receive SMS messages with total energy usage data, powered by Twilio.

## Usage

### GET
```hostname:3000/buildings/```
Will return a JSON file structured as so:
```json
{
    "Electricity": <electricity>,
    "ChilledWater": <chilledWater>,
    "Steam": <steam>,
    "Total": <total>
}
```
All units are kBtu, although the OSISoft dataset supports additional units.

### POST
```hostname:3000/sms/```
Redirect Twilio HTTP POST for SMS here. It receives a building number and returns the total energy usage, also in kBtu.