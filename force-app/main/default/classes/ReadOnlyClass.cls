public class ReadOnlyClass {
    
    public case acct{get;set;}
    public string chk{get;set;}
    public string name{get;set;}
    
    // The extension constructor initializes the private member
    // variable acct by using the getRecord method from the standard
    // controller.
    /*
    public ReadOnlyClass(ApexPages.StandardController stdController) {
        this.acct = (case)stdController.getRecord();
    }*/
    
    public void Check(){
        name = userinfo.getName();
        If(name == 'UmangSinghal')
         chk = 'disabled';
        else
            chk='none';
    }

    public String getGreeting() {
       
        return 'Hello ';
    }
}