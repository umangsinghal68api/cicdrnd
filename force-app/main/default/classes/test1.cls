public class test1 {
    public List<Account> accList {get; set;}
    
    public test1(){
        accList = [SELECT Name, AccountNumber, Phone FROM Account];
    }
    
    public PageReference redirect()
    {
        PageReference pr = new PageReference('/apex/PDFOnClick');
        return pr;
    }
    
    @AuraEnabled
    public static list<account> getAccounts(){
        return [SELECT Id,Name, Industry, (select Id, LastName from contacts) FROM Account Limit 10];
    }
    
    @AuraEnabled
    public static list<Camping_Item__c> getcampingItems(){
        return [SELECT Id,Name, Price__c,Packed__c, Quantity__c  FROM Camping_Item__c ];
    }
    
    @AuraEnabled
    public static void createAccount(Account acc){
        system.debug('acc: ' + acc);
    }
    
    @AuraEnabled
    public static void deleteCampingItemsApex(list<string> delIds){
        system.debug('delIds: ' + delIds);
        Database.DeleteResult[] drList = Database.delete(delIds, false);
        
        // Iterate through each returned result
        for(Database.DeleteResult dr : drList) {
            if (dr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully deleted account with ID: ' + dr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : dr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());
                }
            }
        }
    }
    
    @AuraEnabled
    public static Camping_Item__c createCampingItem(Camping_Item__c campingItem){
        system.debug('campingItem: ' + campingItem);
        insert campingItem;
        return campingItem;
    }
    
    // Controller for test1.cmp 
    @AuraEnabled
    public static Account getAccount(Id accountId){
        Account accObj = [SELECT Id, Name, (SELECT Id, Name FROM Contacts), (SELECT Id, Name FROM Opportunities) FROM Account WHERE Id =: accountId];
        return accObj;
    }
}