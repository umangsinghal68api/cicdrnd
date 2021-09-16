@IsTest
public class TestApprovalLock {     

        @testSetup 
        static void createTestData() { 
            Account a = new Account(Name = 'Test Account A'); 
            insert a; 
            
            Case c = new Case( 
                Subject = 'testcase', 
                AccountId = a.id, 
                Description = 'test' 
            ); 
            insert c; 
            
            Opportunity o = new Opportunity( 
                CloseDate = Date.today(), 
                StageName = 'Closed Won', 
                AccountId = a.Id, 
                Name = 'test oppty' 
            ); 
            
            insert o; 
        } 
        
        @isTest 
        static void LockAndUnlockRecords(){ 
            // lock the records 
            Account a = [select Id, (select id from Cases), (select id from Opportunities) from Account where Name = 'Test Account A']; 
            
            
            /** 
 the latest statement fails with the error 'System.TypeException: Unexpected list type: SObject' */
 List<sObject> lstObjects = new List<SObject>(); 
 lstObjects.addAll((List<sObject>)a.Cases); 
 lstObjects.addAll((List<sObject>)a.Opportunities); 
 List<Approval.LockResult> lockedObjects = Approval.lock(lstObjects); 
/* ==> System.TypeException: Unexpected list type: SObject 
*/ 
            
            /** 
* these statements will lock my records 
 
            List<Approval.LockResult> lockedCases = Approval.lock(a.Cases); 
            List<Approval.LockResult> lockedOpportunities = Approval.lock(a.Opportunities); 
            Id idCase = a.cases[0].Id; 
            Id idOpp = a.Opportunities[0].Id; 
            system.assertEquals(Approval.isLocked(idCase), true); 
            system.assertEquals(Approval.isLocked(idOpp), true); */
        } 
     
}