public class GlobalSearchAccountDemo {
    
    @Auraenabled
    public static list<account> getSearchedAccounts(string searchParam) {
        //email,phone
        //Dynamic query/'
        String emailSearch = '%' + searchParam + '%';
        String phoneSearch = '%' + searchParam + '%';
        list<Account> accList= [Select Id, Name, Phone, Email__c From Account Where email__c like: emailSearch OR phone like: phoneSearch];
        system.debug('accList::'+accList);
        return accList;
    }

}