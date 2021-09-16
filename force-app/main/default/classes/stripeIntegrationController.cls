Public class stripeIntegrationController
{
    @AuraEnabled
    public static string getStripeToken(string strToken, string amount)
    {
        string strMessage='';
        system.debug('strToken=========='+strToken);
        if(strToken != null)
        {
            try 
            {
                StripeCustomer objStripCustomer = StripeCustomer.create(strToken,'MyOrg');
                system.debug('objStripCustomer=========='+objStripCustomer);
                
                StripeCharge objCharge = StripeCharge.create(objStripCustomer.id, Decimal.ValueOf(amount));
                //StripeCard objCharge1 = StripeCard.create(objStripCustomer.id, strToken);
                
            } 
            catch (ListException e) 
            {
                system.debug('ListException =========='+e);
            } 
            catch (Exception e) 
            {
                system.debug('Exception =========='+e);
            } 
            finally 
            {
                system.debug('finally==========');
            } 
            strMessage ='Success';
        }
        else
        {
            strMessage ='token required';
        }
        return strMessage;
    }
}