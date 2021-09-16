public class PayPalButtonController
{
   public string transactionId{get;set;}
   public string paymentId{get;set;}
   public string state{get;set;}
   public decimal amount{get;set;}
   public string  userContactId;
    /*
   public list<Contact> conListToUpdate = New list<Contact>();
   public list<OB_Payment_Details__c> paymentListToInsert = New list<OB_Payment_Details__c>();
   public Set<Contact> conSetToUpdate = New Set<Contact>();
   public Set<OB_Payment_Details__c> paymentSetToInsert = New Set<OB_Payment_Details__c>();
    */
   public PayPalButtonController()
   {
       system.debug('ids::'+ApexPages.currentPage().getParameters().get('id'));
       //Below code is for enables partner portal user on contact record.
       userContactId = [SELECT contactId from User where id=:ApexPages.currentPage().getParameters().get('id')][0].contactId;
       System.debug('UserInfo.getUserId::'+UserInfo.getUserId());
       System.debug('userContactId ::'+userContactId );
       Contact conObj = [SELECT Id,Name,Email FROM Contact WHERE Id =:userContactId];
       amount = 100;                  
      
   } 
   public void savePaymentDetails()
   {
      
      system.debug(''+transactionId+','+paymentId+','+state+','+amount);
      if(String.isnotBlank(transactionId) && String.isnotBlank(paymentId) && String.isnotBlank(state))
      {
          //Update any object.
          /*
         OB_Payment_Details__c objPaymentDetail = New OB_Payment_Details__c();
          objPaymentDetail.OB_Amount__c = amount ;
          objPaymentDetail.OB_Contact__c = userContactId ;
          objPaymentDetail.OB_Payment_Id__c = paymentId ;
          objPaymentDetail.OB_Pyament_Date_Time__c = DateTime.now();
          objPaymentDetail.OB_State__c = state;
          objPaymentDetail.OB_Transaction_Id__c = transactionId ;
          paymentSetToInsert.add(objPaymentDetail);
          
          Contact objCon = New Contact();
          objCon.id = userContactId ;
          objCon.OB_EnrollmentFee__c = amount;
          objCon.OB_Enrollment_Fee_Status_PayPal__c ='Approved';
          objCon.OB_EnrollmentFeeStatus__c ='Approved';
          objCon.OB_EnrollmentDeclarationConsent__c = true;
          objCon.OB_Consent_for_Diploma_Deduction__c = true;
          conSetToUpdate.add(objCon);
          */
      }
       /*
         if(paymentSetToInsert.size()>0)
         {
            paymentListToInsert.addAll(paymentSetToInsert);
            database.insert(paymentListToInsert,false);
         }
         if(conSetToUpdate.size()>0)  
         {
            conListToUpdate.addAll(conSetToUpdate);
            database.update(conListToUpdate,false);
         }
       */
   }
}