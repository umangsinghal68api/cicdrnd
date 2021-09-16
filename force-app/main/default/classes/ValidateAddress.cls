/*
* Created by Umang on 27 July 2017
*/

public class ValidateAddress { 
    
    @AuraEnabled
    public static List<Results> getAddressList(string searchText){
        //Country of the user.
        String country = 'Australia';
        String countryISOCode = '';
        // List of response from Experian.
        List<Results> lstResults = new List<Results>();        
        //Setting the Country ISO Code because ISO code is used in searching by Experian.
        if(country == 'australia') {
            countryISOCode = 'AUS';
        } else if(country == 'canada') {
            countryISOCode = 'CAN';
        } else if(country == 'new zealand') {
            countryISOCode = 'NZL';
        }
        
        //Experian Endpoint saved in custom setting.
        String urlString = 'https://api.edq.com';
        //Experian Token saved in custom setting.
        String token = '417a4d89-4ee6-4bbc-9c6f-1d9f734dd0f9';  
        System.debug('Country ' + country + ' CountryIs0 ' + countryISOCode);
        System.debug('urlString ' + urlString + ' token ' + token);
        urlString = urlString 
            + '/capture/address/v2/search?' 
            + 'country=' + countryISOCode 
            +'&query=' + searchText.replaceAll( '\\s+', '+')
            +'&auth-token=' + token;  
        
        HttpRequest req = new HttpRequest();
        req.setEndPoint(urlString);
        req.setMethod('GET');
        Http http = new Http();
        
        try {
            HTTPResponse res = http.send(req);            
            //system.debug('Result ' + res.getBody());
            JSON2Apex  parsedResponse = new JSON2Apex ();
            parsedResponse = parse(res.getBody());
            lstResults  = parsedResponse.results;
            System.debug('ListOfResults'+lstResults  );
            for(Results objResult : lstResults) {
                System.debug('formatResult'+objResult.format);
            }
        } Catch (Exception e) {
            System.Debug('Exception ' + e);
        }
        return lstResults;      
    }
    
    //Method which make callout and get Addres Details.
    @AuraEnabled
    public static Address getAddressToPopulate(String formatId) {
        String token = '417a4d89-4ee6-4bbc-9c6f-1d9f734dd0f9';        
        String formatUrl = formatId
            +'&auth-token='+ token ;
        Address finalAddress = new Address();
        
        HttpRequest req = new HttpRequest();
        req.setEndPoint(formatUrl);
        req.setMethod('GET');        
        Http http = new Http();
        JSON2ApexAddressResponse parsedAddressResponse = new JSON2ApexAddressResponse();        
        HTTPResponse res = http.send(req);
        parsedAddressResponse  = parseSecond(res.getBody());
        system.debug('parsedAddressResponse ' + parsedAddressResponse.address);
        //Filtering the Address Detail from Eperian Response.
        for(Address objAddress : parsedAddressResponse.address){
            if(objAddress.addressLine1 != null ){
                finalAddress.addressLine1 = objAddress.addressLine1;
            }
            if(objAddress.addressLine2 != null ){
                finalAddress.addressLine2 = objAddress.addressLine2;
            }
            if(objAddress.addressLine3 != null ){
                finalAddress.addressLine3 = objAddress.addressLine3;
            }
            if(objAddress.locality != null ){
                finalAddress.locality = objAddress.locality;
            }
            if(objAddress.province != null ){
                finalAddress.province= objAddress.province;
            } 
            if(objAddress.postalCode != null ){
                finalAddress.postalCode = objAddress.postalCode;
            }
            if(objAddress.country != null ){
                finalAddress.country = objAddress.country;
            }            
        }
        
        for(Components component : parsedAddressResponse.components) {
            if(component.subBuilding1 != null ){
                finalAddress.unitNumber = component.subBuilding1;
            }
            if(component.streetNumber1 != null ){
                finalAddress.streetNumber = component.streetNumber1;
            }
            if(component.street1 != null ){
                finalAddress.streetName = component.street1;
            } 
            if(component.province1 != null ){
                finalAddress.province = component.province1;
            } 
        }
        
        //system.debug('finalAddress ' + finalAddress);
        return finalAddress;
    }    
    
    //Json Wrapper
    public class JSON2Apex {
        public Integer count{get;set;}
        public List<Results> results{get;set;}
    }
    
    // Suggestions when we search for addresses.
    public class Results {
        @AuraEnabled
        public String suggestion;
        @AuraEnabled
        public List<List<Integer>> matched;
        @AuraEnabled
        public String format;
    }    
    
    //Json Parser.
    public static JSON2Apex parse(String json) {
        return (JSON2Apex) System.JSON.deserialize(json, JSON2Apex.class);
    }
    
    // Component received when we make callout with formtaId
    public class Components {
        @AuraEnabled
        public String deliveryPointId1;
        @AuraEnabled
        public String streetNumber1;
        @AuraEnabled
        public String street1;
        @AuraEnabled
        public String locality1;
        @AuraEnabled
        public String province1;
        @AuraEnabled
        public String provinceCode1;
        @AuraEnabled
        public String postalCode1;
        @AuraEnabled
        public String country1;
        @AuraEnabled
        public String countryISO1;
        @AuraEnabled
        public String subBuilding1;
    }
    
    // Json Wrapper
    public class JSON2ApexAddressResponse {
        public List<Address> address;
        public List<Components> components;
    }
    
    // This is a complete Address object.
    public class Address {
        @AuraEnabled
        public String addressLine1;
        @AuraEnabled
        public String addressLine2;
        @AuraEnabled
        public String addressLine3;
        @AuraEnabled
        public String locality;
        @AuraEnabled
        public String province;
        @AuraEnabled
        public String postalCode;
        @AuraEnabled
        public String country;
        @AuraEnabled
        public string unitNumber;
        @AuraEnabled
        public string streetNumber;
        @AuraEnabled
        public string streetName;
    }    
    
    //Json Parser.
    public static JSON2ApexAddressResponse parseSecond(String json) {
        return (JSON2ApexAddressResponse) System.JSON.deserialize(json, JSON2ApexAddressResponse.class);
    }
}