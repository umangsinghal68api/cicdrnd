@RestResource(urlMapping='/MyRestResource/*')
global with sharing class RestMethods {
 
    public class SerilizedObj{
        string Id;
        string Name;
        string TransactionAmt;
    }
    
    @HttpDelete
    global static void doDelete() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Account account = [SELECT Id FROM Account WHERE Id = :accountId];
        delete account;
    }
  
    @HttpGet
    global static String doGet() {
       
        
        /* RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Account result = [SELECT Id, Name, Phone, Website FROM Account WHERE Id = :accountId];*/
         //string finalstr = 'Ordine Id, Numero riga, Nome Articolo, Prezzo di listino, Quantità, Prezzo Totale\na0A2400000WxFFeEAN,1,"SSN-200-RS2,60",7000.000,1.00,7000.000\na0A2400000WxFFeEAN,2,test2,4000.000,1.00,4000.000\na0A2400000WxFFeEAN,3,"SSN-200-RS2,60",3000.000,2.00,6000.000\na0A2400000WxFFeEAN,4,test,2900.000,7.00,20300.000';
         
       // Attachment attachment = new Attachment();
          
         //attachment.Body = Blob.toPdf(finalstr);
         //attachment.Name = String.valueOf('test.pdf');
           
          //attachment.Body = Blob.valueOf(finalstr);
          //attachment.Name = String.valueOf('samplecode.csv');
          //attachment.ParentId = 'a012800000SdK3i'; 
        // insert attachment;
        return 'Success';
    }
  
  @HttpPost
    global static String doPost(String AccName)
    {
        /******************** Convert into CSV file and attach it to Email ans send email ****************************
         * 
       // string finalstr = 'Ordine Id, Numero riga, Nome Articolo, Prezzo di listino, Quantità, Prezzo Totale\na0A2400000WxFFeEAN,1,"SSN-200-RS2,60",7000.000,1.00,7000.000\na0A2400000WxFFeEAN,2,test2,4000.000,1.00,4000.000\na0A2400000WxFFeEAN,3,"SSN-200-RS2,60",3000.000,2.00,6000.000\na0A2400000WxFFeEAN,4,test,2900.000,7.00,20300.000';
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(finalstr);
        string csvname= 'Account.csv';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String[] toAddresses = new list<string> {'usinghal@salesforce.com'}; 
        String subject ='Account CSV';
        email.setSubject(subject);
        email.setToAddresses( toAddresses );
        email.setPlainTextBody('Account CSV');
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        */
        
        List<Bank_Transaction__c> result = [SELECT Id, Name, Transaction_Amt__c FROM Bank_Transaction__c limit 4];
        
        List<SerilizedObj> serilizeObjList = new  List<SerilizedObj>();
        
        for(Bank_Transaction__c BTC : result)
        {
           	SerilizedObj obj = new SerilizedObj();
            obj.Id = BTC.Id;
            obj.Name = BTC.Name;
            obj.TransactionAmt = String.valueOf(BTC.Transaction_Amt__c);
            serilizeObjList.add(obj);
        }        
        
        system.debug('check: ' + json.serialize(serilizeObjList));
        return json.serialize(serilizeObjList);
    }
}