public class EmailTemplateController {
    public Id OppId {get; set;}
    
    public string check {get; set;}
   

    
    public List<Opp_Child__History> getOppChildHistoryList1(){
        
        List<Opp_Child__c> OppChildList = new List<Opp_Child__c>();
        OppChildList = [SELECT Id,Name FROM Opp_Child__c where MasterOpp__c =: OppId];
        system.debug('Oppid= ' + OppId + '  ' + 'List ' + OppChildList);
        
        List<Opp_Child__History> OppChildHistoryList = new List<Opp_Child__History>();
        
        
        for(Opp_Child__c oppChild : OppChildList){
            Opp_Child__History OppChildHistory = new Opp_Child__History();
            OppChildHistory = [SELECT Id,NewValue,OldValue,Field,ParentId FROM Opp_Child__History where field = 'Check_value__c' AND ParentId =: oppChild.Id order by CreatedDate desc limit 1];
            OppChildHistoryList.add(OppChildHistory);
        }
        
        system.debug('List2' + OppChildHistoryList);
        check = 'Its not Working';
        
        return OppChildHistoryList;
    }
    
}