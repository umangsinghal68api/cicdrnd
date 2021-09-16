public class DeleteAccount {
    
    @AuraEnabled
    public static List<Account> getAccounts1(){
        List<Account> accountList = new List<Account>(); 
        return [Select Id, name, industry From Account Order By CreatedDate ASC];
    }
}