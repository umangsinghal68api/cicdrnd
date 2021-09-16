public class EquifaxCanada {
/*



string requestXMLBody = 
    '<?xml version="1.0" encoding="utf-8"?><CNCustTransmitToEfx xmlns="http://www.equifax.ca/XMLSchemas/CustToEfx" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.equifax.ca/XMLSchemas/UAT/CNCustTransmitToEfx.xsd">' +
    '<CNCustomerInfo>' +
    '<CustomerCode>M701</CustomerCode>'+
    '<CustomerInfo>'+
    '<CustomerNumber>999FZ01594</CustomerNumber>'+
    '<SecurityCode>88</SecurityCode></CustomerInfo>'+
    '</CNCustomerInfo>'+
    '<CNRequests>'+
    '<CNCommercialRequest>'+
    '<CustomerInfo>'+
    '<CustomerNumber>999FZ01594</CustomerNumber>'+
    '<SecurityCode>88</SecurityCode></CustomerInfo>'+
    '<FirmName>WESCAM INC</FirmName>'+
    '<Addresses><Address addressType="CURR">'+
    '<CivicNumber>45</CivicNumber>'+
    '<StreetName>Innovation Dr</StreetName><Suite></Suite>'+
    '<City>Dundas</City>'+
    '<Province code="ON"/><PostalCode>L9H7L8</PostalCode>'+
    '</Address></Addresses>'+
    '<ParsedTelephones>'+
    '<ParsedTelephone telephoneType="BUS"><AreaCode></AreaCode><Number></Number><Extension></Extension></ParsedTelephone></ParsedTelephones>'+
    '<FileNumber>0000184721</FileNumber>'+
    '</CNCommercialRequest><CNOutputParameters>'+
    '<Language>EN</Language>'+
    '<OutputParameter outputParameterType="COMM">'+
    '<GenericOutputCode>W</GenericOutputCode>'+
    '<CustomizationCode>VVVF0000</CustomizationCode>'+
    '</OutputParameter>'+
    '</CNOutputParameters>'+
    '</CNRequests>'+
    '</CNCustTransmitToEfx>';
	

string requestXMLBody = 
'<?xml version="1.0" encoding="utf-8"?><CNCustTransmitToEfx xmlns="http://www.equifax.ca/XMLSchemas/CustToEfx" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.equifax.ca/XMLSchemas/UAT/CNCustTransmitToEfx.xsd">'+
'<CNCustomerInfo>'+
'<CustomerCode>M701</CustomerCode>'+
'<CustomerInfo>'+
'<CustomerNumber>999FZ01602</CustomerNumber>'+
'<SecurityCode>88</SecurityCode>'+
'</CustomerInfo>'+
'<CustomerId></CustomerId>'+
'</CNCustomerInfo>'+
'<CNRequests>'+
'<CNConsumerRequests>'+
'<CNConsumerRequest>'+
'<Subjects>'+
'<Subject subjectType="SUBJ">'+
'<SubjectName>'+
'<LastName>TESTLI</LastName>'+
'<FirstName>ANNE</FirstName>'+
'</SubjectName>'+
'<SocialInsuranceNumber></SocialInsuranceNumber>'+
'<DateOfBirth>1988-08-01</DateOfBirth>'+
'<Occupation/>'+
'</Subject>'+
'<Addresses>'+
'<Address>'+
'<CivicNumber>5689</CivicNumber>'+
'<StreetName>Victory St</StreetName>'+
'<City>Vancouver</City>'+
'<Province code="BC" description="British-Columbia"/>'+
'<PostalCode>V3A2B8</PostalCode>'+
'</Address>'+
'</Addresses>'+
'</Subjects>'+
'<CustomerReferenceNumber></CustomerReferenceNumber>'+
'<ECOAInquiryType>I</ECOAInquiryType>'+
'<JointAccessIndicator>N</JointAccessIndicator>'+
'</CNConsumerRequest>'+
'</CNConsumerRequests>'+
'<CNOutputParameters>'+
'<Language>EN</Language>'+
'<OutputParameter outputParameterType="CONS">'+
'<GenericOutputCode>X</GenericOutputCode>'+
'</OutputParameter>'+
'</CNOutputParameters>'+
'</CNRequests>'+
'</CNCustTransmitToEfx>';

string encoded = EncodingUtil.urlEncode(requestXMLBody, 'UTF-8'); 

string check = '<?xml version="1.0" encoding="utf-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sts="https://www.Equifax.ca/EFXWS/STSRequest">' +
    '<soapenv:Body>'+
    '<sts:Submit>'+
    '<sts:InputSegment>%3C%3Fxml%20version%3D%221.0%22%20encoding%3D%22utf-8%22%3F%3E%3CCNCustTransmitToEfx%20xmlns%3D%22http%3A%2F%2Fwww.equifax.ca%2FXMLSchemas%2FCustToEfx%22%20xmlns%3Axsi%3D%22http%3A%2F%2Fwww.w3.org%2F2001%2FXMLSchema-instance%22%20xsi%3AschemaLocation%3D%22http%3A%2F%2Fwww.equifax.ca%2FXMLSchemas%2FUAT%2FCNCustTransmitToEfx.xsd%22%3E%0D%0A%3CCNCustomerInfo%3E%0D%0A%3CCustomerCode%3EM701%3C%2FCustomerCode%3E%0D%0A%3CCustomerInfo%3E%0D%0A%3CCustomerNumber%3E999FZ01602%3C%2FCustomerNumber%3E%0D%0A%3CSecurityCode%3E88%3C%2FSecurityCode%3E%0D%0A%3C%2FCustomerInfo%3E%0D%0A%3CCustomerId%3E%3C%2FCustomerId%3E%0D%0A%3C%2FCNCustomerInfo%3E%0D%0A%3CCNRequests%3E%0D%0A%3CCNConsumerRequests%3E%0D%0A%3CCNConsumerRequest%3E%0D%0A%3CSubjects%3E%0D%0A%3CSubject%20subjectType%3D%22SUBJ%22%3E%0D%0A%3CSubjectName%3E%0D%0A%3CLastName%3ETESTLI%3C%2FLastName%3E%0D%0A%3CFirstName%3EANNE%3C%2FFirstName%3E%0D%0A%3C%2FSubjectName%3E%0D%0A%3CSocialInsuranceNumber%3E%3C%2FSocialInsuranceNumber%3E%0D%0A%3CDateOfBirth%3E1988-08-01%3C%2FDateOfBirth%3E%0D%0A%3COccupation%2F%3E%0D%0A%3C%2FSubject%3E%0D%0A%3CAddresses%3E%0D%0A%3CAddress%3E%0D%0A%3CCivicNumber%3E5689%3C%2FCivicNumber%3E%0D%0A%3CStreetName%3EVictory%20St%3C%2FStreetName%3E%0D%0A%3CCity%3EVancouver%3C%2FCity%3E%0D%0A%3CProvince%20code%3D%22BC%22%20description%3D%22British-Columbia%22%2F%3E%0D%0A%3CPostalCode%3EV3A2B8%3C%2FPostalCode%3E%0D%0A%3C%2FAddress%3E%0D%0A%3C%2FAddresses%3E%0D%0A%3C%2FSubjects%3E%0D%0A%3CCustomerReferenceNumber%3E%3C%2FCustomerReferenceNumber%3E%0D%0A%3CECOAInquiryType%3EI%3C%2FECOAInquiryType%3E%0D%0A%3CJointAccessIndicator%3EN%3C%2FJointAccessIndicator%3E%0D%0A%3C%2FCNConsumerRequest%3E%0D%0A%3C%2FCNConsumerRequests%3E%0D%0A%3CCNOutputParameters%3E%0D%0A%3CLanguage%3EEN%3C%2FLanguage%3E%0D%0A%3COutputParameter%20outputParameterType%3D%22CONS%22%3E%0D%0A%3CGenericOutputCode%3EX%3C%2FGenericOutputCode%3E%0D%0A%3C%2FOutputParameter%3E%0D%0A%3C%2FCNOutputParameters%3E%0D%0A%3C%2FCNRequests%3E%0D%0A%3C%2FCNCustTransmitToEfx%3E</sts:InputSegment>'+
    '<sts:EFXEnvironment></sts:EFXEnvironment>'+  
    '</sts:Submit>'+
    '</soapenv:Body>'+
    '</soapenv:Envelope>';

system.debug(requestXMLBody);

system.debug(encoded);
HttpRequest req = new HttpRequest();
req.setMethod('POST');
req.setEndpoint('https://uat.equifax.ca/STS/ProcessInquiry.asp?InputSegments=' + encoded + '=&cmdSubmit=Submit' );
//req.setHeader('Content-Type', 'text/xml');
req.setTimeout(120000);

req.setBody('');
Http http = new Http();
HTTPResponse res = http.send(req);
system.debug('response: ' + res.getBody());
*/
}