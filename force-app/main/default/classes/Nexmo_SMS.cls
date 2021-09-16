public class Nexmo_SMS {
    /*
    Name	Send SMS	
    Endpoint	https://api.nexmo.com
    API Key	7a9d8784	
    API Secret	8b57dd1cb97122bc
    Brand	MyApp
        
        public static Nexmo_SMS__c objSMS = Nexmo_SMS__c.getInstance('Send SMS');
    @AuraEnabled
    public static String sendSMSRequest(String mob)
    {
        HttpRequest req = new HttpRequest();
        String endPointURL = objSMS.Endpoint__c + '/verify/json?api_key=' + objSMS.API_Key__c + '&api_secret=' + objSMS.API_Secret__c
            +'&number=' + mob + '&brand=' + objSMS.Brand__c;
        req.setEndpoint(endPointURL);
        system.debug(endPointURL);
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        String bodyText = res.getBody();
        String bodyTextUpdated = bodyText.replace('currency','currency_x');
        System.debug(bodyTextUpdated);
        SC2_SMSWrapper wrap = (SC2_SMSWrapper)JSON.deserialize(bodyTextUpdated, SC2_SMSWrapper.class);
        system.debug(wrap.request_id);
        return wrap.request_id;
    }
    @AuraEnabled
    public static String verifySMS(String code, String requestId)
    {
        if(code != null && requestId != null)
        {
            HttpRequest req = new HttpRequest();
            String endPointURL = objSMS.Endpoint__c + '/verify/check/json?api_key=' + objSMS.API_Key__c + '&api_secret=' + objSMS.API_Secret__c+
                '&request_id=' + requestId + '&code=' + code;
            system.debug(endPointURL);
            req.setEndpoint(endPointURL);
            req.setMethod('GET');
            Http http = new Http();
            HTTPResponse res = http.send(req);
            String bodyText = res.getBody();
            String bodyTextUpdated = bodyText.replace('currency','currency_x');
            System.debug(bodyTextUpdated);
            SC2_SMSWrapper wrap = (SC2_SMSWrapper)JSON.deserialize(bodyTextUpdated, SC2_SMSWrapper.class);
            if(wrap.status == '0')
            {
                return 'Success';               
            }
        }
        return null;
    }
*/
}