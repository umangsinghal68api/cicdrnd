public class ReadOnly {
 public List<case> getAllMerchandise() {
        List<case> theMerchandise = 
            [SELECT Id, subject, Field1__c FROM case LIMIT 10];
        return(theMerchandise);
    }
}