public class clicktodial {
	
    public Test__c test{get; set;}

    public clicktodial(ApexPages.StandardController stdController) {
        test = [SELECT Id, Mobile__c, UserName__c FROM Test__c WHERE UserName__c = 'CTI'];
    }

    public Test__c getAccount() {
        return test;
    }

    public PageReference save() {
        update test;
        return null;
    }

}