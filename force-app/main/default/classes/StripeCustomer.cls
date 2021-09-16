/**
* @description - Class is used to retrieve, create and update customer information from stripe.
*/
global class StripeCustomer {
    // String variable to store Service URL
    private static final String SERVICE_URL = 'https://api.stripe.com/v1/customers';
    // Customer TEST id for testing purpose
    global static final String TEST_ID = 'cus_00000000000000';
    // Integer varibale to store Time at which the object was created. 
    global Integer created;
    //Integer variable to capture Current balance, if any, being stored on the customer�s account. 
    global Integer account_balance;
    // String variable  attached to the object. Often useful for displaying to users.
    global String description;
    // Variable for stripe error class.
    global StripeError error;
    // Boolean variable to check callingin live enviroment ot testing enviroment.
    global Boolean livemode;
    // Used to store subscription 
    global StripeSubscription subscription;
    // String varibale is used to store token.
    global String token;
    // String variable is use  to store Id.
    global String id;
    // Map is used to store metadata.
    global Map<String, String> metadata;
    // Variable is used to store card list
    global CardList cards;
    // Variable is used to store default card.
    global String default_card;
    
    // Card List clases is used to store stripe card data.
    global class CardList {
        global Integer count;
        global String url;
        global List<StripeCard> stripeData;
    }

    // static cache to eliminate multiple lookups in same transaction
    private static Map<String, StripeCustomer> mCustomers = new Map<String, StripeCustomer>();
    /**
    * @description - Method is used to get Customer Information in the StripCustomer Class when passign customer Id. 
    *                Here we are creating http request and sending it to get the customer infomration.
    * @param customerId 
    * @return StripeCustomer 
    */
    global static StripeCustomer getCustomer(String customerId) {
        if (mCustomers.containsKey(customerId)) {
            return mCustomers.get(customerId);
        }
        // Creating HTTP request.
        HttpRequest http = new HttpRequest();
        http.setEndpoint(StripeCustomer.SERVICE_URL+'/'+customerId);
        http.setMethod('GET');
        Blob headerValue = Blob.valueOf(StripeAPI.ApiKey + ':');
        String authorizationHeader = 'BASIC ' +
        EncodingUtil.base64Encode(headerValue);
        http.setHeader('Authorization', authorizationHeader);
        
        String response;
        Integer statusCode;
        Http con = new Http();
        HttpResponse hs = new HttpResponse();
        
        if (!Test.isRunningTest()) {
            try {
                hs = con.send(http);
            } catch (CalloutException e) {
                return null;
            }
        } else {
           // hs.setBody(StripeCustomerTests.testData);
            hs.setStatusCode(200);
        }
        system.debug('#### '+ hs.getBody());
        
        response = hs.getBody();
        statusCode = hs.getStatusCode();
        system.debug('$$statusCode = '+hs.getStatusCode());
        
        try {
            StripeCustomer o = StripeCustomer.parse(response);
            System.debug(System.LoggingLevel.INFO, '\n**** Stripe Customer: '+o); 
            //if (o.error != null) throw new StripeException(o.error);
            mCustomers.put(customerId, o);
            return o;
        } catch (System.JSONException e) {
            return null;
        }
    }
    
    /**
    * @description - This method is used to create customer usign token.
    * @param token 
    * @param description 
    * @return StripeCustomer 
    */
    global static StripeCustomer create(String token, String description) {
        Map<String, String> properties = new Map<String, String>{
            'card' => token,
            'description' => description,
                'email' => 'umang.singhal@saasfocus.com'
        };
        return StripeCustomer.create(properties, null);
    }
    
    /**
    * @description - This method is used to create customer using token and plan.
    * @param token 
    * @param plan 
    * @param description 
    * @return StripeCustomer 
    */
    global static StripeCustomer create(String token, String plan, String description) {
        Map<String, String> properties = new Map<String, String>{
            'card' => token,
            'plan' => plan,
            'description' => description
        };
        return create(properties, null);
    }
    
    // DEPRECATED
    global static StripeCustomer create(String token, String plan, String description, Map<String, String> metadata) {
        Map<String, String> properties = new Map<String, String>{
            'card' => token,
            'plan' => plan,
            'description' => description
        };
        return create(properties, metadata);
    }

    global static StripeCustomer create(Map<String, String> properties, Map<String, String> metadata) {
        return updateCustomer(null, properties, metadata);      
    }
    
    // DEPRECATED
    global static StripeCustomer updateCustomer(String customerId, String token, String description) {
        Map<String, String> properties = new Map<String, String>{
            'card' => token,
            'description' => description
        };
        return updateCustomer(customerId, properties, new Map<String, String>());
    }
    
    // DEPRECATED
    global static StripeCustomer updateCustomer(String customerId, String token, String plan, String description) {
        Map<String, String> properties = new Map<String, String>{
            'card' => token,
            'plan' => plan,
            'description' => description
        };
        return updateCustomer(customerId, properties, new Map<String, String>());
    }

    // DEPRECATED
    global static StripeCustomer updateCustomer(String customerId, String token, String plan, String description, Map<String, String> metadata) {
        Map<String, String> properties = new Map<String, String>{
            'card' => token,
            'plan' => plan,
            'description' => description
        };
        return updateCustomer(customerId, properties, metadata);
    }

    /**
    * @description -This method is used to update customer using customer ID.
    * @param customerId 
    * @param properties 
    * @param metadata 
    * @return StripeCustomer 
    */
    global static StripeCustomer updateCustomer(String customerId, Map<String, String> properties, Map<String, String> metadata) {
        HttpRequest http = new HttpRequest();
        
        if (customerId == null) 
            http.setEndpoint(StripeCustomer.SERVICE_URL);
        else 
            http.setEndpoint(StripeCustomer.SERVICE_URL+'/'+customerId);

        http.setMethod('POST');
        Blob headerValue = Blob.valueOf(StripeAPI.ApiKey + ':');
        String authorizationHeader = 'BASIC ' +
        EncodingUtil.base64Encode(headerValue);
        http.setHeader('Authorization', authorizationHeader);
        
        Map<String, String> payload = new Map<String, String>();
        System.debug('payload============='+payload);
        if (properties != null) {
            for (String key : properties.keySet()) {
                if (properties.get(key) != null) {
                    payload.put(key, properties.get(key));
                }
            }
        }
        
        if (metadata != null) {
            for (String key : metadata.keySet()) {
                if (metadata.get(key) != null) {
                    payload.put('metadata['+key+']', metadata.get(key));
                }
            }
        }
        System.debug('payload============='+payload);

        http.setBody(StripeUtil.urlify(payload));
        System.debug(System.LoggingLevel.INFO, '\n**** REQUEST BODY:\n'+http.getBody());    
        
        String response;
        Integer statusCode;
        Http con = new Http();
        HttpResponse hs = new HttpResponse();
        
        if (!Test.isRunningTest()) {
            try {
                hs = con.send(http);
                system.debug('#### [1]'+ hs.getBody());
                
            } catch (CalloutException e) {
                return null;
            }
        } else {
            //hs.setBody(StripeCustomerTests.testData);
            hs.setStatusCode(200);
        }
        
        statusCode = hs.getStatusCode();
        system.debug('$$statusCode =============== '+hs.getStatusCode());
        try {
            StripeCustomer new_customer = StripeCustomer.parse(hs.getBody());
            if (new_customer.error != null) throw new StripeException(new_customer.error);

            System.debug(System.LoggingLevel.INFO, '\n**** Customer: '+new_customer); 
            mCustomers.put(new_customer.id, new_customer);
            return new_customer;
        } catch (System.JSONException e) {
              system.debug('JSONException =============== '+e);
            return null;
        }
    }

    /**
    * @description This method is used to set the default card of customer.
    * @param customerId 
    * @param card 
    * @return StripeCustomer 
    */
    global static StripeCustomer setDefaultCard(String customerId, StripeCard card) {
        Map<String, String> properties = new Map<String, String>{
            'default_card' => card.id
        };
        
        return updateCustomer(customerId, properties, null);
    }

    /**
    * @description - This meethod is used for grant coupon
    * @param customerId 
    * @param coupon 
    * @return StripeCustomer 
    */
    global static StripeCustomer grantCoupon(String customerId, StripeCoupon coupon) {
        Map<String, String> properties = new Map<String, String>{
            'coupon' => coupon.id
        };
        
        return updateCustomer(customerId, properties, null);    
    }

    /**
    * @description - This method is used to cancelo the subscription using customer id.
    * @param customerId 
    * @return StripeSubscription 
    */
    global static StripeSubscription cancelSubscription(String customerId) {
        HttpRequest http = new HttpRequest();
        http.setEndpoint(StripeCustomer.SERVICE_URL+'/'+customerId+'/subscription');
        http.setMethod('DELETE');
        Blob headerValue = Blob.valueOf(StripeAPI.ApiKey + ':');
        String authorizationHeader = 'BASIC ' +
        EncodingUtil.base64Encode(headerValue);
        http.setHeader('Authorization', authorizationHeader);
        
        String response;
        Integer statusCode;
        Http con = new Http();
        HttpResponse hs = new HttpResponse();
        
        if (!Test.isRunningTest()) {
            try {
                hs = con.send(http);
            } catch (CalloutException e) {
                return null;
            }
        } else {
            //hs.setBody(StripeCustomerTests.testData_cancelSubscription);
            hs.setStatusCode(200);
        }

        system.debug('#### '+ hs.getBody());
        
        response = hs.getBody();
        statusCode = hs.getStatusCode();
        
        try {
            StripeSubscription sub = StripeSubscription.parse(response);
            return sub;
        } catch (System.JSONException e) {
            return null;
        }
    }

    /**
    * @description - Cancel Subscription in future method.
    * @param customerId 
    */
    @future (callout=true)
    global static void cancelSubscription_future(String customerId) {
        cancelSubscription(customerId);
    }

    global static StripeSubscription updateSubscription(String customerId, String plan) {
        return updateSubscription(customerId, plan, null);
    }

    /**
    * @description -This method is used to update subscription using customer id.
    * @param customerId 
    * @param plan 
    * @param trial_end 
    * @return StripeSubscription 
    */
    global static StripeSubscription updateSubscription(String customerId, String plan, Date trial_end) {
        HttpRequest http = new HttpRequest();
        http.setEndpoint(StripeCustomer.SERVICE_URL+'/'+customerId+'/subscription');
        http.setMethod('POST');
        Blob headerValue = Blob.valueOf(StripeAPI.ApiKey + ':');
        String authorizationHeader = 'BASIC ' +
        EncodingUtil.base64Encode(headerValue);
        http.setHeader('Authorization', authorizationHeader);
        
        Map<String, String> payload = new Map<String, String>{
            'plan' => plan
        };

        if (trial_end != null) {
            DateTime dt = DateTime.newInstanceGmt(trial_end, Time.newInstance(0, 0, 0, 0));
            Integer utc = (dt.getTime() / 1000).intValue();
            payload.put('trial_end', String.valueOf(utc));
        }
        
        http.setBody(StripeUtil.urlify(payload));   
        System.debug(System.LoggingLevel.INFO, '\n**** REQUEST BODY:\n'+http.getBody());

        String response;
        Integer statusCode;
        Http con = new Http();
        HttpResponse hs = new HttpResponse();
        
        if (!Test.isRunningTest()) {
            try {
                hs = con.send(http);
            } catch (CalloutException e) {
                return null;
            }
        } else {
            //hs.setBody(StripeCustomerTests.testData_updateSubscription);
            hs.setStatusCode(200);
        }

        system.debug('#### '+ hs.getBody());
        
        response = hs.getBody();
        statusCode = hs.getStatusCode();
        
        try {
            StripeSubscription o = StripeSubscription.parse(response);
            return o;
        } catch (System.JSONException e) {
            return null;
        }
    }

    /**
    * @description - This method is used to get the lsit of customer 
    * @param pageSize 
    * @param offset 
    * @return List<StripeCustomer> 
    */
    global static List<StripeCustomer> getCustomers(Integer pageSize, Integer offset) {
        HttpRequest http = new HttpRequest();
        http.setEndpoint(StripeCustomer.SERVICE_URL+'?count='+pageSize+'&offset='+offset);
        http.setMethod('GET');
        Blob headerValue = Blob.valueOf(StripeAPI.ApiKey + ':');
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        http.setHeader('Authorization', authorizationHeader);
        
        String t_json;
        Integer statusCode;
        
        List<StripeCustomer> customers = new List<StripeCustomer>();
        Http con = new Http();
        HttpResponse hs = new HttpResponse();
        
        if (!Test.isRunningTest()) {
            try {
                hs = con.send(http);
            } catch (CalloutException e) {
                return null;
            }
        } else {
            //hs.setBody(StripeCustomerTests.testData_getCustomers);
            hs.setStatusCode(200);
        }

        t_json = hs.getBody();
        statusCode = hs.getStatusCode();
        
        try {
            t_json = StripeUtil.cleanJson(t_json);
            t_json = t_json.substring(t_json.indexOf('['), t_json.lastIndexOf(']')+1);
            customers = (List<StripeCustomer>) JSON.deserialize(t_json, List<StripeCustomer>.class);
            return customers;
            
        } catch (System.JSONException e) {
            return null;
        }
    }
    
    /**
    * @description - Methos is used to get the default card.
    * @return StripeCard 
    */
    public StripeCard getDefaultCard() {
        for (StripeCard card : this.cards.stripeData) {
            if (card.id == this.default_card) {
                return card;
            }
        }

        return null;
    }

    /**
    * @description - this method id used to parse JSON string an get the data in thr form of stripecustomer class.
    * @param json 
    * @return StripeCustomer 
    */
    public static StripeCustomer parse(String json) {
        json = StripeUtil.cleanJson(json);
        return (StripeCustomer) System.JSON.deserialize(json, StripeCustomer.class);
    }

}