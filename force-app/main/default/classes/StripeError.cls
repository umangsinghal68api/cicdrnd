/**
* @description - This class is used to store the error details.
*/
global class StripeError {
   // string variable to store the type of transaction which we are calling 
    global String stripeType;
	// strng variable for parameter.
    global String param;
	// String variable for  detailed message
    global String message;
	// string variable for error code.
    global String code;
}