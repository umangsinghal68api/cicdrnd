public class TestController
{
	public TestController(ApexPages.StandardController controller) 
	{
		 SObject obj = controller.getRecord();

		 if(obj!=null)
		 {
		 	 ObjEntity = (Vehicle__c)obj;
		 }
		 else
		 {
		 	 ObjEntity = new Vehicle__c();
		 }
	}
	
	public Vehicle__c  ObjEntity {get;set;}

	public Void SaveDueFrom()
	{
		system.debug('check: ' + ObjEntity); 
	}
}