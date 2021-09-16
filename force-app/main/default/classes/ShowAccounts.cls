public class ShowAccounts
{
    public string chk {get; set;}

public ShowAccounts(){chk = 'https://ap2.salesforce.com/a002800000VsMPw';}
    
    String s = 'Hello!';
    public string getS()
    
    {
        return s;    
    }
    
    public list<account> Acclist = [Select Id, Name, Rating, Industry From Account];
    
    public list<account> getM1(){
        return acclist ;  
    }
   
    public pagereference DisplayAccounts()
    {
        chk = 'https://ap2.salesforce.com/';
        return new PageReference('/001/o');        
    }

     
}