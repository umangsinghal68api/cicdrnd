public class ContactTriggerHandler {

    public void runing() {
        if (Trigger.isBefore && Trigger.isUpdate) {
            system.debug('Trigger.isBefore && Trigger.isUpdate');
        } 
    }
    
    public void OnAfterInsert(list<test__c> objList) {
        Test_Child__c objChild = new Test_Child__c();
        objChild.TestId__c = objList[0].Id;
        system.debug('testing OnAfterInsert');
        INSERT objChild;
        
    }
}