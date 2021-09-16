public class ConsumerServicesApi {
    /*
    final String BCASERVICE_CLIENT_REF = 'ConsumerServices';
    final String Mode = 'test';
    final String BCASERVICE_CODE = 'BCA011';
    final String BCASERVICE_CODE_VERSION = 'V00';
    final String PRODUCT_NAME = 'consumer-enquiry-nz';
    
    public class CreditFileWrapper {
        public string accountType {get; set;}
        public string enquiryAmount {get; set;}
        public string creditEnquirer {get; set;}
        public string firstGivenName {get; set;}
        public string otherGivenName {get; set;}
        public string clientReference {get; set;}
        public string creditEnquiryDate {get; set;}
    }
    
    public SC_Individual_Response__c sendRequest(CreditAndIdCheckController.CreditAndIdCheckWrapper wrapperObj) {
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(Label.Veda_Test_Url);
        req.setMethod('POST');
        
        String username = Label.UserName_Test;
        String password = Label.Password_Test;
        String body = '<?xml version="1.0" encoding="utf-8"?>'+
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
            '<access-purpose code="'+ wrapperObj.accessPurposeCode +'" />'+
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
            '<gender type="'+ wrapperObj.gender +'" />'+
            '<date-of-birth>'+ wrapperObj.dateOfBirth +'</date-of-birth>'+
            '<address type="current">'+
            '<street-number>'+ wrapperObj.streetName +'</street-number>'+
            '<street-name>Auckland</street-name>'+
            '<street-type code="'+ wrapperObj.streetType +'" />'+
            '<suburb>'+ wrapperObj.suburb +'</suburb>'+
            '<city>'+ wrapperObj.city +'</city>'+
            '</address>'+
            '<address type="previous">'+
            '<street-number></street-number>'+
            '<street-name></street-name>'+
            '<street-type code="" />'+
            '<suburb></suburb>'+
            '<city></city>'+
            '</address>'+
            '<address type="current">'+
            '<street-number></street-number>'+
            '<street-name></street-name>'+
            '<street-type code="" />'+
            '<suburb></suburb>'+
            '<city></city>'+
            '</address>'+
            '<employment>'+
            '<employer></employer>'+
            '<occupation></occupation>'+
            '</employment>'+
            '<phone-details>'+
            '<phone-area-code></phone-area-code>'+
            '<phone-number></phone-number>'+
            '</phone-details>'+
            '<driver-licence-details>'+
            '<licence-number></licence-number>'+
            '<licence-version-number></licence-version-number>'+
            '</driver-licence-details>'+
            '</individual>'+
            '<enquiry joint-account="'+ wrapperObj.jointAccount +'" '+ wrapperObj.guarantor +'="yes" consent="'+ wrapperObj.consent +'">'+
            '<account-type code="" />'+
            '<enquiry-amount></enquiry-amount>'+
            '<client-reference></client-reference>'+
            '</enquiry>'+
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
        req.setTimeout(30000);
        
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
            individualResponseObj.SC_Type__c = 'Consumer Services Check';
            individualResponseObj.SC_Success__c = true;
        } catch (Exception ex) {
            individualResponseObj.SC_Contact__c = wrapperObj.contactId;
            individualResponseObj.SC_Response__c = string.valueof(ex);
            individualResponseObj.SC_Response_Date__c = System.today();
            individualResponseObj.SC_Type__c = 'Consumer Services Check';
            individualResponseObj.SC_Success__c = false;
        }
        
        //System.debug('Consumer Services Check ' + response);
        //callXmlReader(response);
        
        return individualResponseObj;
    }
    
    public List<CreditFileWrapper> callXmlReader(string response){
        List<CreditFileWrapper> creditFileList = new List<CreditFileWrapper>();
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
                } else if ('credit-enquiry' == reader.getLocalName()) { 
                    CreditFileWrapper creditFile = parseCreditResponse(reader);
                    system.debug('credit-enquiry Date: ' + creditFile);
                    creditFileList.add(creditFile);
                    //system.debug('credit-enquiry end');
                } else if ('default' == reader.getLocalName()) {
                    //system.debug('default start');
                    parseDefaultFileResponse(reader);  
                    //system.debug('default end');
                } else if ('date-of-birth' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'date-of-birth');          
                } else if ('correction-reference' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'correction-reference');          
                } else if ('correction-status' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'correction-status');          
                } else if ('correction-text' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'correction-text');          
                } else if ('note' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'note');          
                } else if ('property-ownership-verification-result' == reader.getLocalName()) {                    
                    system.debug('property-ownership-verification-result: ' + reader.getAttributeValue(null, 'verified'));          
                } else if ('property-owner' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'property-owner');          
                } else if ('street-number-from' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'street-number-from');          
                } else if ('street-number-to' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'street-number-to');          
                } else if ('street-name' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'street-name');          
                } else if ('city-district' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'city-district');          
                } else if ('region-description' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'region-description');          
                } else if ('property-reference' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'property-reference');          
                } else if ('electronic-white-pages-result-status' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'electronic-white-pages-result-status');          
                } else if ('displayed-data' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'displayed-data');          
                } else if ('phone-type' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'phone-type');          
                } else if ('narrative' == reader.getLocalName()) {                    
                    parseInnerResponse(reader, 'narrative');          
                }  
            } 
            
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
        return creditFileList;
    }
    
    public void parseDefaultFileResponse(XmlStreamReader reader){
        
        boolean isSafeToGetNextXmlElement = true;
        while(isSafeToGetNextXmlElement) {
            if (reader.getEventType() == XmlTag.END_ELEMENT && 'default' == reader.getLocalName()) {
                break;
            } else if ('load-date' == reader.getLocalName()) {
                parseInnerResponse(reader, 'load-date');
            } else if ('default-date' == reader.getLocalName()) {
                parseInnerResponse(reader, 'default-date');
            } else if ('credit-provider' == reader.getLocalName()) {
                parseInnerResponse(reader, 'credit-provider');
            } else if ('ANZSIC-industry' == reader.getLocalName()) {
                parseInnerResponse(reader, 'ANZSIC-industry');
            } else if ('default-original-amount' == reader.getLocalName()) {
                parseInnerResponse(reader, 'default-original-amount');
            } else if ('default-balance-amount' == reader.getLocalName()) {
                parseInnerResponse(reader, 'default-balance-amount');
            }  else if ('total-loan-amount' == reader.getLocalName()) {
                parseInnerResponse(reader, 'total-loan-amount');
            } else if ('account-type' == reader.getLocalName()) {
                parseInnerResponse(reader, 'account-type');
            } else if ('account-opened-date' == reader.getLocalName()) {
                parseInnerResponse(reader, 'account-opened-date');
            } else if ('default-status' == reader.getLocalName()) {
                parseInnerResponse(reader, 'default-status');
            } else if ('client-account-reference-id' == reader.getLocalName()) {
                parseInnerResponse(reader, 'client-account-reference-id');
            } else if ('family-name' == reader.getLocalName()) {
                parseInnerResponse(reader, 'family-name');
            }  else if ('first-given-name' == reader.getLocalName()) {
                parseInnerResponse(reader, 'first-given-name');
            } else if ('other-given-name' == reader.getLocalName()) {
                parseInnerResponse(reader, 'other-given-name');
            } else if ('date-of-birth' == reader.getLocalName()) {
                parseInnerResponse(reader, 'date-of-birth');
            } else if ('consumer-default-relationship' == reader.getLocalName()) {
                parseInnerResponse(reader, 'consumer-default-relationship');
            }
            
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
    }
    
    public CreditFileWrapper parseCreditResponse(XmlStreamReader reader) {
        
        CreditFileWrapper creditFile = new CreditFileWrapper();
        creditFile.creditEnquiryDate = reader.getAttributeValue(null, 'create-date');
        boolean isSafeToGetNextXmlElement = true;
        while(isSafeToGetNextXmlElement) {
            
            
            if (reader.getEventType() == XmlTag.END_ELEMENT && 'credit-enquiry' == reader.getLocalName()) {
                break;
            } else if ('account-type' == reader.getLocalName()) {
                creditFile.accountType = parseInnerResponse(reader, 'account-type');
            } else if ('enquiry-amount' == reader.getLocalName()) {
                creditFile.enquiryAmount = parseInnerResponse(reader, 'enquiry-amount');
            } else if ('credit-enquirer' == reader.getLocalName()) {
                creditFile.creditEnquirer = parseInnerResponse(reader, 'credit-enquirer');
            } else if ('first-given-name' == reader.getLocalName()) {
                creditFile.firstGivenName = parseInnerResponse(reader, 'first-given-name');
            } else if ('other-given-name' == reader.getLocalName()) {
                creditFile.otherGivenName = parseInnerResponse(reader, 'other-given-name');
            } else if ('client-reference' == reader.getLocalName()) {
                creditFile.enquiryAmount = parseInnerResponse(reader, 'client-reference');
            }
            
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
            
        }
        return creditFile;
    }
    
    public string parseInnerResponse(XmlStreamReader reader, string paramName) {
        string result;
        boolean isSafeToGetNextXmlElement = true;
        while(isSafeToGetNextXmlElement) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                //system.debug('End tag '+reader.getLocalName());
                break;
            } else if (reader.getEventType() == XmlTag.CHARACTERS) {
                //system.debug('char tag '+reader.getLocalName());
                //system.debug(paramName + ' : ' +  reader.getText());
                result = reader.getText();
            }
            // Always use hasNext() before calling next() to confirm 
            // that we have not reached the end of the stream
            if (reader.hasNext()) {
                //system.debug('hasNext '+ reader.getLocalName());
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }
        return result;
    }
    */
}