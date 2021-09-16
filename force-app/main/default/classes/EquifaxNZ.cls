public class EquifaxNZ {
/*
public class IdentityPlusApi {
    
    final String BCASERVICE_CLIENT_REF = 'IdentityCheck';
    final String Mode = 'test';
    final String BCASERVICE_CODE = 'BCA011';
    final String BCASERVICE_CODE_VERSION = 'V00';
    final String PRODUCT_NAME = 'identity-plus-nz';
    final String CLIENT = 'identity-plus-nz';
    
    public SC_Individual_Response__c sendRequest(CreditAndIdCheckController.CreditAndIdCheckWrapper wrapperObj ) {
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(Label.Veda_Test_Url);
        req.setMethod('POST');
        
        String username = Label.UserName_Test;
        String password = Label.Password_Test;
        String body = '<?xml version="1.0" encoding="utf-8"?>' +
            '<BCAmessage type="request">'+
            '<BCAaccess>'+
            '<BCAaccess-code>'+ username +'</BCAaccess-code>'+
            '<BCAaccess-pwd>'+ password +'</BCAaccess-pwd>'+
            '</BCAaccess>'+
            '<BCAservice>'+
            '<BCAservice-client-ref>' + BCASERVICE_CLIENT_REF + '_' + wrapperObj.contactId + '</BCAservice-client-ref>'+
            '<BCAservice-code>'+ BCASERVICE_CODE +'</BCAservice-code>'+
            '<BCAservice-code-version>'+ BCASERVICE_CODE_VERSION +'</BCAservice-code-version>'+
            '<BCAservice-data>'+
            '<request version="V2.0" mode="'+ Mode +'" transaction-reference="'+ wrapperObj.contactId +'">'+
            '<client-details>'+
            '<client-identifier>'+ Label.Client_Identifier_Test +'</client-identifier>'+
            '<operator-id>'+ Label.Operator_Id_Test +'</operator-id>'+
            '</client-details>'+
            '<product name="'+ PRODUCT_NAME +'" />'+
            '<individual>'+
            '<individual-name>'+
            '<family-name>'+ wrapperObj.familyName +'</family-name>'+
            '<first-given-name>'+ wrapperObj.firstGivenName +'</first-given-name>'+
            '<other-given-name></other-given-name>'+
            '</individual-name>'+
            '<date-of-birth>'+ wrapperObj.dateOfBirth +'</date-of-birth>'+
            '<gender>'+ wrapperObj.gender +'</gender>'+
            '<current-address>'+
            '<street-number></street-number>'+
            '<street-name>'+ wrapperObj.streetName +'</street-name>'+
            '<street-type>'+ wrapperObj.streetType +'</street-type>'+
            '<suburb>'+ wrapperObj.suburb +'</suburb>'+
            '<city>'+ wrapperObj.city +'</city>'+
            '</current-address>'+
            '<previous-addresses>' +
            '<previous-address>' +
            '<street-number></street-number>' +
            '<street-name></street-name>' +
            '<street-type></street-type>'+
            '<suburb></suburb>'+
            '<city></city>'+
            '</previous-address>'+
            '<previous-address>'+
            '<street-number></street-number>'+
            '<street-name></street-name>'+
            '<street-type></street-type>'+
            '<suburb></suburb>'+
            '<city></city>'+
            '</previous-address>'+
            '<previous-address>'+
            '<street-number></street-number>'+
            '<street-name></street-name>'+
            '<street-type></street-type>'+
            '<suburb></suburb>'+
            '<city></city>'+
            '</previous-address>'+
            '</previous-addresses>'+                        
            '</individual>'+
            '<client-reference></client-reference>'+
            '<access-purpose-code>'+ wrapperObj.accessPurposeCode +'</access-purpose-code>'+
            '<consent>'+ wrapperObj.consent +'</consent>'+
            '</request>'+
            '</BCAservice-data>'+
            '</BCAservice>'+
            '</BCAmessage>';
        
        //system.debug('body ' + body); 
        
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type','text/xml');
        req.setBody(body);
        
        // Create a new http object to send the request object
        // A response object is generated as a result of the request  
        
        Http http = new Http();
        
        SC_Individual_Response__c individualResponseObj = new SC_Individual_Response__c();
        
        try {
            HTTPResponse res = http.send(req);
            string response = String.valueof(res.getBody());
            individualResponseObj.SC_Contact__c = wrapperObj.contactId;
            individualResponseObj.SC_Response__c = response;
            individualResponseObj.SC_Response_Date__c = System.today();
            individualResponseObj.SC_Type__c = 'ID Check';
            if(checkErrorInResponse(response)) {
                individualResponseObj.SC_Success__c = false;
            } else {
                individualResponseObj.SC_Success__c = true;
            }            
        } catch (Exception ex) {
            individualResponseObj.SC_Contact__c = wrapperObj.contactId;
            individualResponseObj.SC_Response__c = string.valueof(ex);
            individualResponseObj.SC_Response_Date__c = System.today();
            individualResponseObj.SC_Type__c = 'ID Check';
            individualResponseObj.SC_Success__c = false;
        }        
        
        //System.debug('Id Check ' + response);        
        //callXmlReader(response);
        
        return individualResponseObj;
    }
    
    public boolean checkErrorInResponse (string response) {
        
        XmlStreamReader reader = new XmlStreamReader(response);
        
        boolean isSafeToGetNextXmlElement = true;
        boolean isErrorInResponse = false;
        
        while(isSafeToGetNextXmlElement) {
            
            if (reader.getEventType() == XmlTag.START_ELEMENT) {                
                if ('error-description' == reader.getLocalName()) {                    
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
    
    public void callXmlReader(string response) {
        
        XmlStreamReader reader = new XmlStreamReader(response);
        
        boolean isSafeToGetNextXmlElement = true;
        
        while(isSafeToGetNextXmlElement) {
            
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                
                //system.debug('Tag: ' + reader.getLocalName());
                
                if ('BCAservice-code' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'BCAservice-code');          
                } else if ('BCAservice-code-version' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'BCAservice-code-version');          
                } else if ('BCAservice-client-ref' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'BCAservice-client-ref');          
                } else if ('verification-reference' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'verification-reference');          
                } else if ('confidence-rating' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'confidence-rating');          
                } else if ('confidence-level' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'confidence-level');          
                } else if ('consumer-entity-match' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'consumer-entity-match');          
                } else if ('alert-message-code' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'alert-message-code');          
                } else if ('alert-message-text' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'alert-message-text');          
                } else if ('family-name-match' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'family-name-match');          
                } else if ('first-given-name-match' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'first-given-name-match');          
                } else if ('other-given-name-match' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'other-given-name-match');          
                } else if ('date-of-birth-match' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'date-of-birth-match');          
                } else if ('current-address-match' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'current-address-match');          
                } else if ('street-number-match' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'street-number-match');          
                } else if ('street-name-match' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'street-name-match');          
                } else if ('street-type-match' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'street-type-match');          
                } else if ('suburb-match' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'suburb-match');          
                } else if ('city-match' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'city-match');          
                } else if ('error-description' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'error-description');          
                }   
            } 
            
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
    }
    
    public void parseInnerResponse(XmlStreamReader reader, string paramName) {
        
        boolean isSafeToGetNextXmlElement = true;
        while(isSafeToGetNextXmlElement) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            } else if (reader.getEventType() == XmlTag.CHARACTERS) {
                system.debug(paramName + ' : ' +  reader.getText());
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
    }
    
}
*/
}