@isTest 
public class QueueableExampleOneTest { 
    
    private static testMethod void one(){ 
        
        QueueableExampleOne job = new QueueableExampleOne(); 
        job.max = 3; 
        System.enqueueJob(job); 
        
    } 
    
}