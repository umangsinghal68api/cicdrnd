public class ChkExtApi {
    
    public void check(){

		/* GET
		 
        HttpRequest req = new HttpRequest();
       //req.setEndpoint('http://maps.googleapis.com/maps/api/geocode/xml?address=77379&sensor=true');
        req.setEndpoint('https://umangsinghal-dev-ed.my.salesforce.com/services/apexrest/MyRestResource');
        req.setMethod('Post');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');	
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());
        
		*/
        
/************************************ GET WITH AUTHENTICATION *********************************************************************************************************************/
        
     /*
      * 
     HttpRequest req = new HttpRequest();
     req.setEndpoint('http://49.50.66.31:9899/?reqtype=login&user=SF1&pass=a12345&exten=4001&host=192.168.1.1_SF1&service=6&login=login');
     req.setMethod('GET');
     
     // Specify the required user name and password to access the endpoint
     // As well as the header and header information
 
     String username = 'SF1';
     String password = 'a12345';
  
     Blob headerValue = Blob.valueOf(username + ':' + password);
     String authorizationHeader = 'BASIC ' +
     EncodingUtil.base64Encode(headerValue);
     req.setHeader('Authorization', authorizationHeader);
   
     // Create a new http object to send the request object
     // A response object is generated as a result of the request  
  
     Http http = new Http();
     HTTPResponse res = http.send(req);
     System.debug(res);
	
	*/
        
/*********************************************************** POST ***********************************************************************************************/
       String accId =  '0012800000Y0H0HAAV';
        List<Contact> contactList = [SELECT 
                                                      	Id, Name
                                                      FROM 
                                                      	Contact
                                                      WHERE 
                                                      accountID=: accId];
                                                      
        string header = 'Account Id, S.No., Contact Id, Contact Name \n';
        string finalstr = header;
        integer i = 1;
        
        for(Contact contactObj : contactList)
        {
        	string recordString = '"' + accId + '","' + i + '","' + contactObj.Id + '","' + contactObj.Name + '"\n';
            finalstr = finalstr +recordString;
            i++;
        }
        
        
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        
         String username = 'umangsinghal68@gmail.com';
         String password = 'Salesforce@1234';
      
         Blob headerValue = Blob.valueOf(username + ':' + password);
         String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
         req.setHeader('Authorization', authorizationHeader);

        req.setEndpoint('https://umangsinghal-dev-ed.my.salesforce.com/services/apexrest/MyRestResource');
        req.setMethod('POST');
        req.setBody('name='+EncodingUtil.urlEncode(finalstr, 'UTF-8'));
        req.setCompressed(true); // otherwise we hit a limit of 32000

        try 
        {
            res = http.send(req);
        } 
        
        catch(System.CalloutException e) 
        {
            System.debug('Callout error: '+ e);
            System.debug(res.toString());
        }
        
    }
}