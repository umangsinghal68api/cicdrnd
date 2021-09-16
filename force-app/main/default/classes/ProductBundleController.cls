public class ProductBundleController {
    
    public class ProductBundleWrapper {
        @AuraEnabled
        public Product2 productBundle {get; set;}
        @AuraEnabled
        public List<Product2> productList {get; set;}
    }
    
    @AuraEnabled
    public static ProductBundleWrapper getProduct(string productName) {
        list<ProductBundleWrapper> a = new list<ProductBundleWrapper>();
        system.debug('productName ' + productName);
        ProductBundleWrapper productBundleWrapperObj = new ProductBundleWrapper();
        List<Product2> productList = new List<Product2>();
        Product2 productBundleObj = [Select Id, Name, (select Id,Product__c from Product_Bundles__r), 
                                     (Select Id,UnitPrice, Product2Id From PricebookEntries where Pricebook2Id = '01s2800000DUsZo') 
                                     from product2
                                     where 
                                     Name =: productName limit 1];
        system.debug('productBundleObj ' + productBundleObj);
        
        productBundleWrapperObj.productBundle = productBundleObj;
        set<id> productOfBundleIds = new set<Id>();
        //productOfBundleIds.add(productBundleObj.Id);
        if(productBundleObj.Product_Bundles__r.Size() > 0) {
            for(Product_Bundle__c productBundle : productBundleObj.Product_Bundles__r) {
                productOfBundleIds.add(productBundle.product__c);
            }
            //set<id> productOfBundleIds = (new Map<Id,SObject>(productBundle.Product_Bundles__r)).keySet();
            system.debug('productOfBundleIds ' + productOfBundleIds);
            list<Product2> productOfBundleList = [Select Id, Name, (select Id,Product__c from Product_Bundles__r), 
                                                  (Select Id,UnitPrice, Product2Id From PricebookEntries where Pricebook2Id = '01s2800000DUsZo') 
                                                  from product2
                                                  where 
                                                  Id IN : productOfBundleIds];
            system.debug('productOfBundleList ' + productOfBundleList);
            productBundleWrapperObj.productList = productOfBundleList;
        }
        
        a.add(productBundleWrapperObj);
        system.debug('a ' + a[0].productBundle.Name);
        return productBundleWrapperObj;
    }
}