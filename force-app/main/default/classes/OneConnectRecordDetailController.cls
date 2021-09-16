public class OneConnectRecordDetailController {
    
  @AuraEnabled 
  public static List<LayoutSection> GetPageLayoutFields(String pageLayoutAPIName ) {
      
    List<LayoutSection> sectionsList = new List<LayoutSection>();
      
    try {
      // Provide the page layout name here
      // You can give multiple page layout names here as well
      List<String> componentNameList = new List<String>{pageLayoutAPIName};
      // Retrieve page layout details 
      List<Metadata.Metadata> components = Metadata.Operations.retrieve(Metadata.MetadataType.Layout, componentNameList);

      Metadata.Layout componentLayout = (Metadata.Layout) components.get(0);

      // We are going to find the fields names and will keep them according to columns so 
      // we can show them as per page layout 
      for( Metadata.LayoutSection ls : componentLayout.layoutSections ) {

        LayoutSection section = new LayoutSection( ls.label, ls.layoutColumns.size() );

        List<LayoutColumn> columnsList = new List<LayoutColumn>();
        Integer maxFieldsInColumn = 0;
          for( Metadata.LayoutColumn lc : ls.layoutColumns ) {
            LayoutColumn column = new LayoutColumn();
            // check if there are fields available in that column
            if( lc.layoutItems != null ) { 
              // Get the max number of fields in a column to preserve the alignment 
              if( maxFieldsInColumn < lc.layoutItems.size() ) {
                maxFieldsInColumn = lc.layoutItems.size();
              }

              for( Metadata.LayoutItem li : lc.layoutItems ) {
              // Pass the LayoutItem object in the LayoutField consturctor	    
                column.fieldsList.add( new LayoutField( li ) );
              }
            }
            // No need to add a column in the section if there is no field available 
            if( column.fieldsList.size() > 0 ) {
              columnsList.add( column );
            }
          }
          // Now, we need to arrange the fields in section so we can use them in the iteration 
          // on the component so we will have to arrange them in the order 
          if( maxFieldsInColumn > 0 ) {
            for( Integer i = 0; i < maxFieldsInColumn; i++ ) {
              for( Integer j = 0; j < columnsList.size(); j++ ){
                if( columnsList[j].fieldsList.size() > i ) {
                  section.fieldsList.add( columnsList[j].fieldsList[i] );
                }    
                else {
                  section.fieldsList.add( new LayoutField() );
                }
              }
            }
          }

          sectionsList.add( section );
      }
    }
    catch( Exception e ){
      System.assert(false, e.getLineNumber() + ' : ' + e.getMessage() );
    }
    return sectionsList;
  }

  @AuraEnabled
  public static string GetObjectAPIName(Id recordId){
    try {
      string recordIdName = recordId.getSObjectType().getDescribe().getName();
      return recordIdName;
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }

  
  private class LayoutColumn {
    private List<LayoutField> fieldsList;
    public LayoutColumn() {
      this.fieldsList = new List<LayoutField>();
    }
  }
  
  public class LayoutField {
    @AuraEnabled public String fieldName;
    @AuraEnabled public Boolean isRequired;
    @AuraEnabled public Boolean isReadOnly;
    
    public LayoutField() {}
    
    public LayoutField( Metadata.LayoutItem li ) {
        
      this.fieldName = li.field;
      if( li.behavior == Metadata.UiBehavior.Required ) {
        this.isRequired = true;
      }
      else if( li.behavior == Metadata.UiBehavior.ReadOnly ) {
        this.isReadOnly = true;
      }
    }
  }

  public class LayoutSection {
    @AuraEnabled public String label;
    @AuraEnabled public List<LayoutField> fieldsList;
    @AuraEnabled public Integer totalColumns;
    public LayoutSection( String label, Integer totalColumns ) {
      this.label = label;
      this.totalColumns = totalColumns;
      this.fieldsList = new List<LayoutField>();
    }
  }
}