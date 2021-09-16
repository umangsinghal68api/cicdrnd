public class triggerTest {

    public static void chkExistingRecord(list<Opportunity> ops){
        
        double totalAmount = 0;
        
       /* for(Opportunity o : [Select Amount from Opportunity Where CreatedDate = Today AND CreatedById = :Userinfo.getUserId()])
        {
            totalAmount += o.Amount;
        }*/
        
        for(Opportunity o : ops)
        {
            totalAmount += o.Amount;
            
            if(totalAmount > 5000)
            {
                o.adderror('can not delete trigger');
            }
            
        }     
        
    }
    
}