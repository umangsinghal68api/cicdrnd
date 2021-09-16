public class PaginationController {
  
    @AuraEnabled
    public static integer getCount(){        
        return [Select count() from case];
    }
    
    @AuraEnabled
    public static List<Account> getAccounts(){        
        return [select Id, Name, (Select Id, name from contacts) from account where Id IN ('0012800000Y0H09AAF', '0012800000Y0H0FAAV', '0012800000hBU2qAAG', '0012800000smvlCAAQ')];
    }
    
    @AuraEnabled
    public static List<case> getCases(integer offsetValue, integer pageSize){ 
        system.debug('value' + pageSize);
        Integer offsets = integer.valueof(offsetValue);
        Integer pageSizeIninteger = integer.valueof(pageSize);
        
        List<case> caseList = new List<case>();
        caseList = [Select Id,subject, Priority from case order by Id limit : pageSizeIninteger OFFSET : offsets];
        return caseList;
    }
}