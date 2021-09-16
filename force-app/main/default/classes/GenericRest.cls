public class GenericRest {
    
    public static void run() {
        List<Object> objList = [Select Id, Name, 
                                (Select Id, Name From Contacts Limit 1), 
                                (Select Id, Name, StageName From Opportunities Limit 1), 
                                (Select Id, CaseNumber, Description From Cases Limit 1)
                                From Account Limit 5];
        list<lightningTableWrapper> ltw = new list<lightningTableWrapper>();
        lightningTableWrapper l = new lightningTableWrapper();
        l.page = 3;
        l.total = 4;
        ltw.add(l);
        
        //List<Map<String, Object>> masterMap = getMasterMap(objList, false);
        Map<String, List<Map<String,Object>>> masterData = new Map<String, List<Map<String,Object>>>();
        Map<String,Object> mapObj = new Map<String,Object>();
        List<Map<String,Object>> mapList = new List<Map<String,Object>>();
        mapList.add(new Map<String,Object>{'Name' => 'test','Site' => 'Industry'});
        masterData.put('A1', mapList);
        List<Map<String,Object>> mapList1 = new List<Map<String,Object>>();
        mapList1.add(new Map<String,Object>{'FirstName' => 'C1A','LastName' => 'C1A'});
        mapList1.add(new Map<String,Object>{'FirstName' => 'C1B','LastName' => 'C1B'});
        masterData.put('C1', mapList1);
        List<Map<String,Object>> mapList2 = new List<Map<String,Object>>();
        mapList2.add(new Map<String,Object>{'FirstName' => 'C2A','LastName' => 'C2A'});
        mapList2.add(new Map<String,Object>{'FirstName' => 'C2B','LastName' => 'C2B'});
        masterData.put('C2', mapList2);
        List<Map<String,Object>> mapList3 = new List<Map<String,Object>>();
        mapList3.add(new Map<String,Object>{'FirstName' => 'C3A','LastName' => 'C3A'});
        mapList3.add(new Map<String,Object>{'FirstName' => 'C3B','LastName' => 'C3B'});
        masterData.put('C3', mapList3);
        List<Map<String,Object>> mapList4 = new List<Map<String,Object>>();
        mapList4.add(new Map<String,Object>{'Id' => 'O1A','Status' => 'Done'});
        mapList4.add(new Map<String,Object>{'Id' => 'O1B','Status' => 'NotDone'});
        masterData.put('O1', mapList4);
        List<Map<String,Object>> mapList5 = new List<Map<String,Object>>();
        mapList5.add(new Map<String,Object>{'Id' => 'O2A','Status' => 'NotDone'});
        mapList5.add(new Map<String,Object>{'Id' => 'O2B','Status' => 'Done'});
        masterData.put('O2', mapList5);
        List<Map<String,Object>> mapList6 = new List<Map<String,Object>>();
        mapList6.add(new Map<String,Object>{'Id' => 'OLI1A','TotalPrice' => 1.0});
        mapList6.add(new Map<String,Object>{'Id' => 'OLI1B','TotalPrice' => 2.5});
        masterData.put('OLI1', mapList6);
        List<Map<String,Object>> mapList7 = new List<Map<String,Object>>();
        mapList7.add(new Map<String,Object>{'Id' => 'OLI2A','TotalPrice' => 1.3});
        mapList7.add(new Map<String,Object>{'Id' => 'OLI2B','TotalPrice' => 2.7});
        masterData.put('OLI2', mapList7);
        //system.debug('mapList::'+masterData);
        List<GenericRest__mdt> jsonMetadata = [Select Label, DeveloperName, IsParentNode__c, Mapping__c,Sequence__c From GenericRest__mdt order by Sequence__c desc];
        getJson(jsonMetadata, masterData);
    }
    
    public static list<String> getSortedNode(List<GenericRest__mdt> jsonMetadata, map<string, string> finalMap) {
        List<String> sortedNodes = new List<String>();
        for(GenericRest__mdt metaData : jsonMetadata) {
            if(metaData.Sequence__c != 0) {                
                sortedNodes.add(metaData.DeveloperName);
            } else {
                for(String key : finalMap.keySet()) {
                    if(metaData.Mapping__c.contains('<<'+key+'>>')) {
                        system.debug('yes');
                    }
                }
            }
        }        
        system.debug('sortedNodes::'+sortedNodes);            
        return sortedNodes;
    }
    
    public static String getJson(List<GenericRest__mdt> jsonMetadata, Map<String, List<Map<String,Object>>> masterData) {
        List<String> sortedNodes = getSortedNode(jsonMetadata, null);
        String finalJson;
        Map<String, String> jsonDatatoNodeMap = new Map<String, String>();
        for(GenericRest__mdt genericJson : jsonMetadata) {
            //system.debug('========'+genericJson.DeveloperName +'   '+ masterData.get(genericJson.DeveloperName) + '============');
            if(!genericJson.IsParentNode__c)
                jsonDatatoNodeMap.put(genericJson.DeveloperName, getFilledJson(genericJson.Mapping__c, masterData.get(genericJson.DeveloperName)));            
        }
        system.debug('jsonDatatoNodeMap::'+jsonDatatoNodeMap);
        map<string, string> finalMap = createParentNode(jsonDatatoNodeMap, sortedNodes);
        getSortedNode(jsonMetadata, finalMap);
        //system.debug('goAgain::'+goAgain);
        return finalJson;
    }
    
    public static map<string, string> createParentNode(Map<String, String> jsonDatatoNodeMap, List<String> sortedNodes) {
        map<string, string> tempMap = new map<string, string>();
        for(String key : sortedNodes) {
            String tempStr = jsonDatatoNodeMap.get(key);
            //system.debug('tempStrBefore::'+tempStr);
            for(String innerKey : jsonDatatoNodeMap.keySet()) {
                if(tempStr.contains('<<'+innerKey+'>>')) {
                    //system.debug('innerKey::'+innerKey +'-'+jsonDatatoNodeMap.get(innerKey));
                    tempStr = tempStr.replaceAll('"<<'+innerKey+'>>"', jsonDatatoNodeMap.get(innerKey));
                    system.debug(jsonDatatoNodeMap.put(key,tempStr));
                    tempMap.put(key,tempStr);
                }            
            }            
        }        
        
        //system.debug('tempMap::'+tempMap);
        return tempMap;        
    }
    
    public static String getFilledJson(String mapping, List<Map<String,Object>> nodeData) {
        Map<String, Object> jsonMap = (Map<String, Object>)JSON.deserializeUntyped(mapping);
        //system.debug('jsonMap::'+jsonMap);
        List<Map<String,Object>> arrayNode = new List<Map<String,Object>>();
        for(Map<String,Object> fieldValue : nodeData) {            
            map<string,Object> tempMap = new map<string,Object>();
            for(String key : jsonMap.keySet()) {
                //system.debug('jsonMap.get(key).toString()::'+key+'-'+fieldValue.get(key));
                if(fieldValue.get(key) != Null) {
                    string value = jsonMap.get(key).toString().remove('<<').remove('>>');
                    tempMap.put(key, fieldValue.get(value)); 
                } else {
                    tempMap.put(key, jsonMap.get(key));
                }
                
            }
            //system.debug('tempMap::'+tempMap);
            arrayNode.add(tempMap);
        }
        //system.debug('arrayNode Json::'+Json.serialize(arrayNode));
        return Json.serialize(arrayNode);
    }
    public static List<Map<String, Object>> getMasterMap(list<Object> objList, boolean isWrapper) {
        List<Map<String, Object>> masterMap = new List<Map<String, Object>>();
        //System.debug(JSON.serialize(objList));
        String typeOfParentObj = getObjectType(objList[0]);
        Pattern pat = Pattern.compile('("attributes".+?},)');
        string cleanRecord = pat.matcher(JSON.serialize(objList,true)).replaceAll('');
        //System.debug(cleanRecord);
        
        //string cleanRecord = '{"Id":"0012800000V19ugAAB","Contacts":[{"Id":"0032800000L0UVZAA3"}]}' ;
        //Map<string,Object> 
        //  mapq = (Map<string,Object>)JSON.deserializeUntyped(cleanRecord); 
        //System.debug(mapq);
        
        for(Object o :(list<object>)JSON.deserializeUntyped(cleanRecord)) {
            Map<String, Object> objKeyValuePair = getkeyValue((Map<string,Object>)o, typeOfParentObj);
        }
        return masterMap;
    }
    
    Public static Map<string,Object> getkeyValue(Map<string,Object> objMap, String typeOfParentObj) {
        Map<string,Object> objKeyValuePair = new Map<string,Object>();
        System.debug('Obj::' + objMap);
        for(String key : objMap.keySet()) {
            String typeOfObject = getObjectType(objMap.get(key));
            if(typeOfObject == 'String') {
                objKeyValuePair.put(typeOfParentObj+'.'+key, objMap.get(key));
            } else {                
                system.debug('>>Size:: Key-'+key +' '+ typeOfObject);
                Object obj = objMap.get(key);
                system.debug('Contacts::');
            }
        }
        return objKeyValuePair;
    }
    
    public static String getObjectType(Object obj) {        
        String result = 'DateTime';
        try {
            Time typeCheck = (Time)obj;
        }
        catch(System.TypeException ex) {            
            String message = ex.getMessage().substringAfter('Invalid conversion from runtime type ');
            result = message.substringBefore(' to Time');
        }        
        return result;
    }
}