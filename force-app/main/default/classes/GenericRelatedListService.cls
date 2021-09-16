/*
* Created By	: Umang Singhal
* Date			: Apr 04, 2018
* Company		: Individual 
*/
public class GenericRelatedListService {
    // Used to send the data of fields to the lightning component.
    @AuraEnabled
    public static InnerClass getRelatedList(string parentObj, string childObj, string queryFields, string numberOfRecords, string recordId, string sObjectType) {
        string query = 'SELECT Id, ( SELECT ' + queryFields + ' FROM ' + childObj + ') FROM ' + parentObj + ' WHERE Id = \'' + recordId + '\'';   
        system.debug('query::' + query);
        sObject sObj = Database.query(query);
        InnerClass auraResponse = new InnerClass();
        auraResponse.Obj = sObj;
        auraResponse.fieldApiToLabelMap = getRelatedListFieldLabel(sObjectType);                
        system.debug('auraResponse::' + auraResponse.Obj);
        system.debug('auraResponse::' + auraResponse.fieldApiToLabelMap);
        return auraResponse;
    }
    
    public static map<string,string> getRelatedListFieldLabel(string sObjectType) {
        map<string,string> fieldApiToLabelMap = new map<string,string>();
        map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(sObjectType);
        map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        
        for (String fieldName: fieldMap.keySet()) {   
            System.debug('##Field API Name='+fieldName + '::' + fieldMap.get(fieldName).getDescribe().getLabel());// list of all field API name
            fieldApiToLabelMap.put(fieldName,fieldMap.get(fieldName).getDescribe().getLabel());
        }
        return fieldApiToLabelMap;
    }
    
    public with sharing class InnerClass
    {
        @AuraEnabled
        public sObject Obj {get; set;}        
        @AuraEnabled
        public  map<string,string> fieldApiToLabelMap {get; set;}
    }
}