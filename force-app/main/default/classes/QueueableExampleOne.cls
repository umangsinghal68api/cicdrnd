public class QueueableExampleOne implements Queueable, Database.AllowsCallouts { 
    
    public Integer max; 
    
    private Integer counter = 1; 
    
    
    public void execute(QueueableContext context){ 
        
        QueueableExampleOne job = new QueueableExampleOne(); 
        job.max = max; 
        job.counter = counter+1; 
        if(max >= job.counter) { 
            System.enqueueJob(job); 
        } 
    } 
}