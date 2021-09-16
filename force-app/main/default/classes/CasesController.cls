public class CasesController {
    private ApexPages.StandardSetController standardController;
    
    public CasesController(ApexPages.StandardSetController standardController)
    {
        this.standardController = standardController;
    }
        
    public PageReference updateCases()
    {       
        // Call StandardSetController 'save' method to update (optional, you can use your own DML)
        return standardController.save();
    }
}