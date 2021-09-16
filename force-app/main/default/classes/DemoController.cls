public without sharing class DemoController {
    @AuraEnabled
    public static list<account> getAccounts(){
        return [SELECT Id,Name, Industry, (select Id, LastName from contacts) FROM Account Limit 5];
    }
}