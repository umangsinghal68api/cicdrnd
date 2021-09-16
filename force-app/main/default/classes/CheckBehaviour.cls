global with sharing class CheckBehaviour {
    
    webservice static String[] createCase(String caseId) {
        String[] result = new List<String> { '0', '' };
            
            Case caseObj = new Case(
                ContactId = '0032800000Od27r',
                AccountId = '0012800000Y0H0H',
                Status = 'Working',
                Origin = 'Phone');
        
        caseObj.ParentId = caseId;
        
        insert caseObj;
        
        result[1] = caseObj.Id;
        
        return result;
    }
    
}