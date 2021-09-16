public class CustomCommunityLoginController {
    public String username{get; set;}
    public String password {get; set;}
    public string errormsg {get; set;}
    
    public pageReference doLogin()
    {  
        
        List<User> a = [SELECT Id FROM User Where Username =: username];
        boolean success = false;
        
        if(a.Size() > 0)
            success=true;
        else
            success=false;
        
        pageReference  result = Site.login(username,password,null);
        
        if(success)
            
            if(result != null)
            result.setRedirect(true);
        	else
            errormsg = '* Incorrect Password'; 
        else
        { errormsg = '* Incorrect Username'; }
        
        return result;
    }
    
    
    public PageReference forwardTocustomStartPage() {
        PageReference pageRef = new PageReference('/CustomCommunitySelfRegistration');
        pageRef.setRedirect(true);
        
        return pageRef;
    }
}