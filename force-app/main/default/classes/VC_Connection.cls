public class VC_Connection 
{
    public string Name {get; set;}
    public integer Age;
    
   
    public void setAge(integer a)
    {
        Age = a;
    }
    
    public integer getAge()
    {
        return Age;
    }
	
    
    public pagereference save1()
    {
        return (page.FirstPage);
    }
    
}