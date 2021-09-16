/**
* @description - Class is used to create card using customer id and token and return the response.
*/
global class StripeCard {
    // strign private varible to store the callout URL.
    private static final String SERVICE_URL = 'https://api.stripe.com/v1/customers/';
	//string varibel 
    global String stripeType;
	//Two-letter ISO code representing the country of the card.
    global String country;
	//Two digit number representing the card�s expiration month.
    global Integer exp_month;
	//Uniquely identifies this particular card number.
    global String fingerprint;
	//Four digit number representing the card�s expiration year.
    global Integer exp_year;
	//string varibel to store last four digits of the device account number.
    global String last4;
	// String variable representing the object�s type.
    global String stripeObject;
	// string variable to store the Unique identifier for the object..
    global String id;
	//string variable for Cardholder name. 
    global String name;
	// variable to hold the values of error in stripe error object.
    global StripeError error;
	// string variable for customer id.
    global String customer_id;
    
    /**
    * @description - return the expiration date
    */
    global Date expirationDate {
        get {
            Date d = Date.newInstance(this.exp_year, this.exp_month, Date.daysInMonth(this.exp_year, this.exp_month));
            return d;
        }
    }

    /**
    * @description - Method is used to create card using customer id and token.
    * @param customerId 
    * @param token 
    * @return StripeCard 
    */
    global static StripeCard create(String customerId, String token) {
        HttpRequest http = new HttpRequest();
        http.setEndpoint(SERVICE_URL + customerId + '/cards');
        http.setMethod('POST');
        Blob headerValue = Blob.valueOf(StripeAPI.ApiKey + ':');
        String authorizationHeader = 'BASIC ' +
        EncodingUtil.base64Encode(headerValue);
        http.setHeader('Authorization', authorizationHeader);
        
        Map<String, String> payload = new Map<String, String>{
            'card' => token
        };

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
            hs.setBody(StripeCardTests.testData_getCard);
            hs.setStatusCode(200);
        }

        system.debug('#### '+ hs.getBody());
        
        response = hs.getBody();
        statusCode = hs.getStatusCode();
        
        try {
            StripeCard o = StripeCard.parse(response);
            System.debug(System.LoggingLevel.INFO, '\n**** StripeCard object: '+o); 
            return o;
        } catch (System.JSONException e) {
            System.debug(System.LoggingLevel.INFO, '\n**** JSONException: '+e); 
            return null;
        }
    }

    /**
    * @description - Method is used to parse JSON string and return stripe card information.
    * @param json 
    * @return StripeCard 
    */
    public static StripeCard parse(String json) {
        // rough string replacement to simplify json parsing and avoid Apex reserved words
        json = StripeUtil.cleanJson(json);

        return (StripeCard) System.JSON.deserialize(json, StripeCard.class);
    }
    
}