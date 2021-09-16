@istest(SeeAllData=false)
public class BatchScheduleTest {
    static testmethod void test() {
        Test.startTest();
        
        Account a = new Account();
        a.Phone = '1234567890';
        a.Name = 'testBatchSchedular';
        insert a;
        
        // Schedule the test job
        
        String jobId = System.schedule('testBatchSchedule',
                                       BatchSchedule.CRON_EXP, 
                                       new BatchSchedule());
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals(BatchSchedule.CRON_EXP, ct.CronExpression);
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run
        System.assertEquals('2019-03-27 10:57:00', String.valueOf(ct.NextFireTime));
        System.assertNotEquals('0987654321',
                               [SELECT id, name, Phone FROM account WHERE id = :a.id].Phone);
        
        Test.stopTest();
        	
        //System.assertEquals('0987654321', [SELECT Id, Name, Phone FROM Account WHERE Id = :a.Id].Phone);        
    }
}