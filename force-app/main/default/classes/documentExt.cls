public class documentExt {
    
    Public boolean chk {get;set;}
    public Case aCase {get;set;}
    public string issues {get;set;}
    
    public documentExt(ApexPages.StandardController controller) {
        Document d = (Document) controller.getRecord();
        d.folderid = UserInfo.getUserId(); //this puts it in My Personal Documents
        chk = false;
    }  
    
    public PageReference setvalue(){
        if(issues=='Other')
        chk = true;
        else
            chk=false;
        return null;
    }
}