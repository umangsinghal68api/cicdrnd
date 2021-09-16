public class checkboxWrapper {
    
    public class wrapperClass{
        @AuraEnabled public boolean isSelected;
        @AuraEnabled public Account acc;
        
        public wrapperClass(){
            isSelected = false;
            acc = new Account();
        }
    }
    
    @AuraEnabled
    public static List<wrapperClass> getAccounts(){
        
        List<Account> accList = new List<Account>();
        accList = [Select Id, Name from Account Limit 10];
        
        List<wrapperClass> wrapperClassList = new List<wrapperClass>();
        
        if(accList != Null && accList.size()>0){
            for(Account acc : accList){
                wrapperClass wc = new wrapperClass();
                wc.acc = acc;
                wrapperClassList.add(wc);
            }
        }
        
        return wrapperClassList;
    }
    
    @AuraEnabled
    public static string getSObject(List<wrapperClass> wrapperClassList){
        system.debug('value: ' + wrapperClassList);
        return 'success';
    }
}