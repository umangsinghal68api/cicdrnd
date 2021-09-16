public class EquifaxAus {
/*
public class CreditCheckForAustralia {
    
    public static list<EquifaxInteration__mdt> data() {
        list<EquifaxInteration__mdt> integrationData;
         string country = 'Australia';
         string instance;
        Organization salesforceInstance = [SELECT Id, Name, IsSandbox FROM Organization LIMIT 1];
        
        if(salesforceInstance.IsSandbox) {
           instance = 'TEST';
           integrationData = [SELECT MasterLabel, Instance__c, URL__c, Password__c, Username__c, Type__c
                              FROM EquifaxInteration__mdt WHERE Country__c =: country AND Instance__c =: instance];
        } else {
            instance = 'PRODUCTION';
            integrationData = [SELECT MasterLabel, Instance__c, URL__c, Password__c, Username__c, Type__c
                               FROM EquifaxInteration__mdt WHERE Country__c =: country AND Instance__c =: instance];
        }
        return integrationData;
    }
    
    public static boolean checkBusinessCredit(string ACN) {
        string  URL;
        string  username;
        string  password;
        string  bureauScore;
        boolean result = false;
        Trigger_Switch__c switchCustomSetting;
        
        switchCustomSetting       = Trigger_Switch__c.getOrgDefaults();
        Date goLiveDate           = Date.valueOf(switchCustomSetting.Go_Live_Date__c);
        
        list<Account> lstAccount  = new list<Account>();
        lstAccount                = [SELECT id,name,SC_Business_Last_Credit_Check_Date__c,ACN__c,SC_ACN__c  FROM ACCOUNT WHERE SC_ACN__c =: ACN AND createddate >=: goLiveDate limit 1];
        
        if(!lstAccount.isEmpty()){
            if(lstAccount[0].SC_Business_Last_Credit_Check_Date__c != NULL && (lstAccount[0].SC_Business_Last_Credit_Check_Date__c.daysBetween(System.Today())) <= 90)
                return true;
        }
        
        for(EquifaxInteration__mdt data : data()){
            if(data.Type__c == 'BusinessCreditCheck') {
                URL = data.URL__c;
                username = data.Username__c;
                password = data.Password__c;
            }
        }
        
        string XML = createXMLRequestForBusiness(username, password, ACN);
        //system.debug('XML ' + XML);
        HTTPResponse calloutResponse = makeCallout(URL, XML);
        string response = String.valueof(calloutResponse.getBody());
        
        if(checkErrorInResponse(response)) {
            system.debug('Error in Response.');
        } else {
            bureauScore = callXmlReader(response);
            system.debug('bureauScore ' + bureauScore);
        }  
        
        if(String.isNotEmpty(bureauScore)) {
            result = true;
            if(!lstAccount.isEmpty()){
                lstAccount[0].SC_Business_Last_Credit_Check_Date__c = System.today();
                update lstAccount;
            }
        }
        
        
        list<SC_Business_Respose__c> lstBusinessResponse = new list<SC_Business_Respose__c>();
        SC_Business_Respose__c BusinessInstance          = new SC_Business_Respose__c();
        if(!lstAccount.isEmpty()){
             BusinessInstance.SC_Account__c       = lstAccount[0].id;
             BusinessInstance.SC_Response_Date__c = system.today();
             BusinessInstance.SC_Success__c       = result;
             BusinessInstance.SC_Type__c          = 'Credit Check';
             BusinessInstance.SC_JSON_Response__c = response;
             lstBusinessResponse.add(BusinessInstance);
        }
         
        if(!lstBusinessResponse.isEmpty()){
             insert lstBusinessResponse;
        }
         
        return result;
    }
    
    public static boolean checkIndividualCredit(List<contact> lstContact){
        
        list<SC_Individual_Response__c> lstIndividualResponse = new list<SC_Individual_Response__c>();
        
        String URL                 = '';
        String username            = ''; 
        String password            = '';
        String genderCode          = '';   
        String scoreMasterScale    = '';
        boolean tempResult         = false;
        set<Boolean> finalResult   = new set<Boolean>();
        map<id,boolean> mapContact = new map<id,boolean>();
         
        if(!lstContact.isEmpty()){
            
            for(EquifaxInteration__mdt data : data()) {
                if(data.Type__c == 'IndividualCreditCheck') {
                    URL         = data.URL__c;
                    username    = data.Username__c;
                    password    = data.Password__c;
                }
            }
            
            for(Contact conInstance : lstContact){
                
                string lastName   = '';
                string firstName  = '';
                string streetName = '';
                string suburb     = '';
                string state      = '';
                string gender     = '';
                scoreMasterScale  = '';
                tempResult        = false;
                
                if(conInstance.SC_Individual_Last_Credit_Check_Date__c != NULL && (conInstance.SC_Individual_Last_Credit_Check_Date__c.daysBetween(System.Today())) <= 90){
                    tempResult = true;
                }
                else{
                    lastName   = conInstance.LastName;
                    firstName  = conInstance.firstName;
                    streetName = conInstance.OtherStreet;
                    suburb     = conInstance.OtherCity;
                    state      = conInstance.OtherState;
                    gender     = conInstance.Gender__c;
                    
                    if(gender.toLowerCase() == 'female') {
                        genderCode = 'F';
                    } else if(gender.toLowerCase() == 'male') {
                        genderCode = 'M';
                    } else {
                        genderCode = 'UnKnown';
                    }
                    
                    string XML = createXMLRequestForContact(username, password, lastName, firstName, streetName, suburb, state, genderCode);
                    HTTPResponse calloutResponse = makeCallout(URL, XML);
                    string response = String.valueof(calloutResponse.getBody());
                    
                    if(checkErrorInResponse(response)) {
                        system.debug('Error in Response.');
                    }
                    else{
                        scoreMasterScale = callXmlReader(response);
                        system.debug('scoreMasterScale ' + scoreMasterScale);
                    } 
                    
                    if(String.isNotEmpty(scoreMasterScale)) {
                        tempResult = true;
                    }
                    
                    SC_Individual_Response__c IndividualResponseInstance = new SC_Individual_Response__c();
                    IndividualResponseInstance.SC_Contact__c             = conInstance.id;
                    IndividualResponseInstance.SC_Response_Date__c       = system.today();
                    IndividualResponseInstance.SC_Success__c             = tempResult;
                    IndividualResponseInstance.SC_Type__c                = 'Credit Check';
                    IndividualResponseInstance.SC_Response__c            = response;
                    lstIndividualResponse.add(IndividualResponseInstance);
                }
                
                finalResult.add(tempResult);
                mapContact.put(conInstance.id,tempResult);
            }
        }
        
        if(!lstIndividualResponse.isEmpty()) {
             insert lstIndividualResponse;
        }
        
        if(!lstContact.isEmpty()){
            for(Contact conInstance : lstContact){
                if(mapContact.get(conInstance.id)){
                    conInstance.SC_Individual_Last_Credit_Check_Date__c = system.today();
                }
            }
            update lstContact;
        }
        
        if(finalResult.contains(false)){
            return false;
        }
        else{
            return true;
        }
        
    }  
    
    public static HTTPResponse makeCallout(string URL, string XML) {
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(URL);
        req.setHeader('Content-Type', 'text/xml');
        req.setTimeout(120000);
        req.setBody(XML);
        Http http = new Http();
        HTTPResponse res = http.send(req);
        return res;
    }
    
    public static string createXMLRequestForBusiness(string username, string password, string ACN) {
        string XML = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:com="http://vedaxml.com/vxml2/company-enquiry-v3-2.xsd" xmlns:wsa="http://www.w3.org/2005/08/addressing">' +
            '<soapenv:Header>' +
            '<wsse:Security mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">' +
            '<wsse:UsernameToken>'+
            '<wsse:Username>'+ username +'</wsse:Username>'+
            '<wsse:Password>'+ password +'</wsse:Password>'+
            '</wsse:UsernameToken>'+
            '</wsse:Security>'+
            '<wsa:MessageID>urn:example.com:123456789</wsa:MessageID>'+
            '<wsa:To>https://vedaxml.com/sys2/company-enquiry-v3-2</wsa:To>'+
            '<wsa:Action>http://vedaxml.com/companyEnquiry/ServiceRequest</wsa:Action>'+
            '</soapenv:Header>'+
            '<soapenv:Body>'+
            '<com:request request-type="REPORT">'+
            '<com:bureau-reference></com:bureau-reference>'+
            '<com:subject role="principal">'+
            '<com:australian-company-number>' + ACN + '</com:australian-company-number>'+
            '</com:subject>'+
            '<com:current-historic-flag>current-and-historical</com:current-historic-flag>'+
            '<com:enquiry type="credit-enquiry">'+
            '<com:account-type code="CR">COMMERCIALRENTAL</com:account-type>'+
            '<com:enquiry-amount currency-code="AUD">25000</com:enquiry-amount>'+            
            '<com:co-borrower></com:co-borrower>'+            
            '<com:client-reference></com:client-reference>'+
            '</com:enquiry>'+
            '<com:collateral-information>'+
            '<com:credit-type>COMMERCIAL</com:credit-type>'+
            '<com:scoring-required>yes</com:scoring-required>'+          
            '<com:enrichment-required>no</com:enrichment-required>'+
            '<com:ppsr-required>no</com:ppsr-required>'+
            '</com:collateral-information>'+
            '</com:request>'+
            '</soapenv:Body>'+
            '</soapenv:Envelope>';
        return XML;
    }
    
    public static string createXMLRequestForContact(string username, string password, string lastName, string firstName, string streetName, string suburb, string state, string genderCode) {
        string XML = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:vh="http://vedaxml.com/soap/header/v-header-v1-10.xsd" xmlns:ved="http://vedaxml.com/vxml2/vedascore-apply-v2-0.xsd">'+
            '<soapenv:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">'+
            '<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">'+
            '<wsse:UsernameToken>'+
            '<wsse:Username>'+ username +'</wsse:Username>'+
            '<wsse:Password>'+ password +'</wsse:Password>'+
            '</wsse:UsernameToken>'+
            '</wsse:Security>'+
            '<wsa:To>http://vedaxml.com/sys2/vedascore-apply-v2-0</wsa:To>'+
            '<wsa:Action>http://vedaxml.com/vedascore-apply/EnquiryRequest</wsa:Action>'+
            '</soapenv:Header>'+
            '<soapenv:Body>'+
            '<ved:request>'+
            '<ved:enquiry-header>'+
            '<ved:permission-type-code>XY</ved:permission-type-code>'+
            '<ved:product-data-level-code>N</ved:product-data-level-code>'+
            '</ved:enquiry-header>'+
            '<ved:enquiry-data>'+
            '<ved:individual>'+
            '<ved:current-name>'+
            '<ved:family-name>'+ lastName +'</ved:family-name>'+
            '<ved:first-given-name>'+ firstName +'</ved:first-given-name>'+
            '</ved:current-name>'+
            '<ved:addresses>'+
            '<ved:address type="C">'+
            '<ved:street-name>'+ streetName +'</ved:street-name>'+
            '<ved:suburb>'+ suburb +'</ved:suburb>'+
            '<ved:state>'+ state +'</ved:state>'    +
            '</ved:address>' +          
            '</ved:addresses>' +              
            '<ved:gender-code>'+ genderCode +'</ved:gender-code>'+
            '</ved:individual>'+
            '<ved:enquiry>'+
            '<ved:account-type-code>CR</ved:account-type-code>'+
            '<ved:enquiry-amount currency-code="AUD">25000</ved:enquiry-amount>'+
            '<ved:relationship-code>1</ved:relationship-code>'+
            '</ved:enquiry>'+
            '</ved:enquiry-data>'+
            '</ved:request>'+
            '</soapenv:Body>'+
            '</soapenv:Envelope>';
        return XML;
    } 
    
    public static boolean checkErrorInResponse (string response) {        
        XmlStreamReader reader = new XmlStreamReader(response);        
        boolean isSafeToGetNextXmlElement = true;
        boolean isErrorInResponse = false;
        
        while(isSafeToGetNextXmlElement) {            
            if (reader.getEventType() == XmlTag.START_ELEMENT) {                
                if ('error-description' == reader.getLocalName()) {                    
                    isErrorInResponse = true;          
                } else if('faultcode' == reader.getLocalName()) {
                    isErrorInResponse = true; 
                }
            }
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }        
        return isErrorInResponse;
    }
    
    public static string callXmlReader(string response) {
        string score;
        XmlStreamReader reader = new XmlStreamReader(response);        
        boolean isSafeToGetNextXmlElement = true;
        
        while(isSafeToGetNextXmlElement) {            
            if (reader.getEventType() == XmlTag.START_ELEMENT) {                
                //system.debug('Tag: ' + reader.getLocalName());                
                if ('bureau-score' == reader.getLocalName()) {
                    score = parseInnerResponse(reader, 'bureau-score');          
                }
                if ('score-masterscale' == reader.getLocalName()) {
                    score = parseInnerResponse(reader, 'score-masterscale');          
                } 
            } 
            
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
        return score;
    }
    
    public static string parseInnerResponse(XmlStreamReader reader, string paramName) {
        boolean isSafeToGetNextXmlElement = true;
        string result;
        while(isSafeToGetNextXmlElement) {
            if (reader.getEventType() == XmlTag.END_ELEMENT && paramName == reader.getLocalName()) {
                break;
            } else if (reader.getEventType() == XmlTag.CHARACTERS && !reader.isWhiteSpace()) {                
                system.debug(paramName + ' 1:1 ' +  reader.getText());
                result = reader.getText();
            }
            // Always use hasNext() before calling next() to confirm 
            // that we have not reached the end of the stream
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
        return result;
    }
}
*/
}