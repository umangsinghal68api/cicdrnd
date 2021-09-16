global class MyWebservices {
        
Global class wrapperAccount{
        public string accName {get;set;}
        webservice string site {get; set;}
    }
    
    webservice static Id createAccount(wrapperAccount wAccount){
    system.debug('wAccount' + wAccount);
        Account acc = new Account();
        acc.Name= wAccount.accName ;
        acc.Site = wAccount.site;
        
        insert acc;
        system.debug('Id' + acc.Id);
        return acc.Id;
    }
    
    public static Id createAccount2(wrapperAccount wAccount){
    system.debug('wAccount' + wAccount);
        Account acc = new Account();
        acc.Name= wAccount.accName ;
        acc.Site = wAccount.site;
        
        insert acc;
        system.debug('Id' + acc.Id);
        return acc.Id;
    }
}