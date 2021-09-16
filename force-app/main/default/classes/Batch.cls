global with sharing class Batch implements Database.Batchable<sObject>{
    
  global String qry='';
  
  public Batch(){
    qry = 'Select Id, Name, Phone from Account';
  }
  
  global Iterable<sObject> start(Database.BatchableContext BC){
    System.debug('Query is '+qry);
    return Database.getQueryLocator(qry);
  }
    
  global void execute(Database.BatchableContext BC, list<sObject> scope){
      system.debug('scope is ' + scope);
      
      List<Account> acc = new List<Account>();
      acc = (list<Account>)scope;   
      
      system.debug('acc is ' + acc);
      
      for(Account a : acc)
      {
          a.Phone = '0987654321';
          update a;
          system.debug('a is ' + a);
      }
  }
  
  global void finish(Database.BatchableContext BC){
    
    }    
}