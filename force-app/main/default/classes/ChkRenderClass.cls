public class ChkRenderClass {
String uname;
Integer count = 0;
    
    public Integer getCount() {
        return count;
    }

    public ChkRenderClass(){
 	
    }

    public String getUsername() {
        return uname;
    }
             

    public PageReference sayHello() {     
        uname = UserInfo.getName();
        count++;
        return null;
    }

        public PageReference say() {
        
        return null;
    }    
    
    public void setState(String n) {
        state = n;
    }             

    
    public String getState() {
        return state;
    }             

    
    public PageReference methodOne() {
        return null;
    }             

    
    private String state = 'no';

}