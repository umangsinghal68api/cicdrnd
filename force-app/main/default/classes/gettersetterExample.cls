public class gettersetterExample {
    
    public String userinput;
    public String getuserinput(){return 'John';}
    
    public void setuserinput(String userinput)
    {
        this.userinput = userinput;
        system.debug('this.userinput ' + this.userinput);
    }
    
    @AuraEnabled
    public static List<Account> getAccounts(){
        return [select Id, Name from account limit 10];
    }
    
     @AuraEnabled
    public static void setAccounts(Account acc){
        
    }
}