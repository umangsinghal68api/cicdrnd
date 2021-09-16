/**
* @description - Class is used to retrieve and create a charge object.
*/
global class StripeCharge {
    private static final String SERVICE_URL = 'https://api.stripe.com/v1/charges';
    //A positive integer in the smallest currency unit 
    global Integer amount;
    //Time at which the object was created
    global Integer created;
    //Three-letter ISO currency code, in lowercase.
    global String stripeCurrency;
    //ID of the customer this charge is for if one exists.
    global String customer_id;
    // Variable to store the stripe customer information.
    global StripeCustomer customer;
    // Often useful for displaying to users.
    global String description;
    //Details about the dispute if the charge has been disputed.
    global Boolean disputed;
    //
    global Integer fee;
    //
    global String id;
    //Flag indicating whether the object exists in live mode or test mode.
    global Boolean livemode;
    //
    global String stripeObject;
    //true if the charge succeeded, or was successfully authorized for later capture.
    global Boolean paid;
    // If the charge is only partially refunded, this attribute will still be false.
    global Boolean refunded;
    //Amount in cents refunded
    global Integer amount_refunded;
    //
    global StripeCard card;
    //Detailed breakdown of fees (in cents) paid for this transaction.
    global List<Fee_details> fee_details;
    // Object to store th
    global StripeError error;
    //ID of the invoice this charge is for if one exists.
    global String invoice_id;
    // Object to store the invoice details.
    global StripeInvoice invoice;
    //Message to user further explaining reason for charge failure if available.
    global String failure_message;
    // It can be useful for storing additional information about the object in a structured format.
    global Map<String, String> metadata;

    // This has changed in the 2013-02-13 API
    // https://stripe.com/docs/upgrades#2013-02-13
    // And more recently on 2013-08-13
    // https://stripe.com/docs/upgrades#2013-08-13

    /**
    * @description - Class is used to store the fee details. 
    */
    global class Fee_details {
        //string variable is used to store stripe type information.
        global String stripeType;
        //An arbitrary string which you can attach to a Charge object.
        global String description;
        //A fee in cents that will be applied to the charge and transferred to the application owner's Stripe account. 
        global Object application;
        // A positive integer in the smallest currency unit
        global Integer amount;
        //3-letter ISO code for currency.
        global String stripeCurrency;
    }

    /**
    * @description - Method is used to get the charge information by passing charge id.
    * @param chargeId 
    * @return StripeCharge 
    */
    global static StripeCharge getCharge(String chargeId) {
        return StripeCharge.getCharge(chargeId, false);
    }
    
    /**
    * @description -Method is used to get the charge information by passing charge id.
    * @param chargeId 
    * @param expandInvoice 
    * @return StripeCharge 
    */
    global static StripeCharge getCharge(String chargeId, Boolean expandInvoice) {
        HttpRequest http = new HttpRequest();
        String endPoint = SERVICE_URL+'/'+chargeId;
        if (expandInvoice) endPoint += '?expand[]=invoice';
        System.debug(System.LoggingLevel.INFO, '\n**** StripeCharge.getCharge endpoint: '+endPoint); 
        http.setEndpoint(endPoint);
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
            //hs.setBody(StripeChargeTests.testData_getCharge);
            hs.setStatusCode(200);
        }

        system.debug('#### '+ hs.getBody());
        
        response = hs.getBody();
        statusCode = hs.getStatusCode();
        
        try {
            StripeCharge o = StripeCharge.parse(response);
            return o;
        } catch (System.JSONException e) {
            System.debug(System.LoggingLevel.INFO, '\n**** '+e); 
            return null;
        }
    }
    
    /**
    * @description - method is used to create charge object by passing customer id and amount.
    * @param customerId 
    * @param amount 
    * @return StripeCharge 
    */
    global static StripeCharge create(String customerId, Decimal amount) {
        return create(customerId, amount, new Map<String, String>(), new Map<String, String>());
    }
    
    // DEPRECATED
    global static StripeCharge create(String customerId, Decimal amount, String description) {
        Map<String, String> properties = new Map<String, String>{
            'description' => description
        };
        
        return create(customerId, amount, properties, null);
    }

    // DEPRECATED
    global static StripeCharge create(String customerId, Decimal amount, String description, Map<String, String> metadata) {
        Map<String, String> properties = new Map<String, String>{
            'description' => description
        };
        
        return create(customerId, amount, properties, metadata);
    }

    /**
    * @description - Method is used to create charge.
    * @param customerId 
    * @param amount 
    * @param properties 
    * @param metadata 
    * @return StripeCharge 
    */
    global static StripeCharge create(String customerId, Decimal amount, Map<String, String> properties, Map<String, String> metadata) {
        HttpRequest http = new HttpRequest();
        http.setEndpoint(SERVICE_URL);
        http.setMethod('POST');
        Blob headerValue = Blob.valueOf(StripeAPI.ApiKey + ':');
        String authorizationHeader = 'BASIC ' +
        EncodingUtil.base64Encode(headerValue);
        http.setHeader('Authorization', authorizationHeader);
        
        Integer amount_int = Math.round(amount * 100);//.intValue();
        Map<String, String> payload = new Map<String, String>{
            'customer' => customerId,
            'amount' => String.valueOf(amount_int),
                'receipt_email' => 'umangsinghal68@gmail.com'
        };

        // set the default currency to USD if it's not specified
        if (properties == null || properties.containsKey('usd') == false) {
            payload.put('currency', 'usd');
        }

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
            //hs.setBody(StripeChargeTests.testData_createCharge);
            hs.setStatusCode(200);
        }

        system.debug('#### '+ hs.getBody());
        
        response = hs.getBody();
        statusCode = hs.getStatusCode();
        system.debug('$$statusCode = '+hs.getStatusCode());
        
        try {
            StripeCharge o = StripeCharge.parse(response);
            System.debug(System.LoggingLevel.INFO, '\n**** StripeCharge object: '+o); 
            return o;
        } catch (System.JSONException e) {
            System.debug(System.LoggingLevel.INFO, '\n**** JSONException: '+e); 
            return null;
        }
    }

    /**
    * @description - Method is used to parse JSON and return charge object.
    * @param json 
    * @return StripeCharge 
    */
    public static StripeCharge parse(String json) {
        // rough string replacement to simplify json parsing and avoid Apex reserved words
        json = StripeUtil.cleanJson(json);

        return (StripeCharge) System.JSON.deserialize(json, StripeCharge.class);
    }
}