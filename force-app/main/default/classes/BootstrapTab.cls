public class BootstrapTab {
    
    public BootstrapTab(){
        
    }
    
    Public 	Vehicle__c vehicleObject;
    
    public void setvehicleObject (Vehicle__c s) {
        vehicleObject = s;
    }
    public Vehicle__c getvehicleObject() {
        return vehicleObject;
    }
    
    @RemoteAction
    public static void saveVehicle(Vehicle__c abc) {
        system.debug('check:' + abc);
    }
    
    @RemoteAction
    public static pagereference DisplayAccounts1()
    {
        return new PageReference('https://ap2.salesforce.com/a002800000VsMPw');        
    }
    
}