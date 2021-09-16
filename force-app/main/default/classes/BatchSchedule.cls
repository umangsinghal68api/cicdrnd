global class BatchSchedule implements Schedulable {
    
    public static String CRON_EXP = '0 57 10 27 MAR ?';
    
    //Schedule execution
    global void execute( SchedulableContext SC ) {  
        Batch b = new Batch(); 
        Database.executeBatch(b, 200);
    } 
    
    /*************** To Schedule a Job
String CRON_EXP = '6 27 * * * ?';
BatchSchedule sch = new BatchSchedule();
system.schedule('Batch', CRON_EXP, sch);
*/
    
}