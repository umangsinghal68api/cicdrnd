/*
 * Created By	:	Umang Singhal
 * Created Date	:	June, 06th 2018
 * MotorWeb Integration Saasfocus
 */

public class MotorWebService {
    //Wrapper class for the motorWebService.
    public class MotorWebRequest {
        public String endPointUrl	{get; set;}	//End point uri of Motor Web.
        public String method 		{get; set;}	//Metohd will be GET, POST etc.
        public String encodedUri 	{get; set;}	//It is the uri that we are using in creating the signature.
        public String publicKey 	{get; set;}	//Username of the production/sandbox environment.
        public String privateKey 	{get; set;}	//Password of the production/sandbox environment.
        public String contentType 	{get; set;}	//Content type of request.
        public String algoName		{get; set;}	//name of the algo used to create signature
    }
    
    private static String invoke(MotorWebRequest request) {    
        try {            
            DateTime currentDate= System.now();
            Long epoch			= currentDate.getTime() / 1000;            
            String signature 	= getSignature(request, epoch);
            String authorizationHeader = 'Shared ' + request.publicKey + ':' + signature;
            
            //Creating a http request
            HttpRequest req = new HttpRequest();
            req.setHeader('Accept', request.contentType);
            req.setHeader('Authorization', authorizationHeader);
            req.setHeader('X-Date', string.valueOfGmt(currentDate));
            req.setEndpoint(request.endPointUrl);
            req.setMethod(request.method);
            
            //Sending http request
            Http http = new Http();
            HTTPResponse res = http.send(req);
            return res.getBody(); //Parse the response as per the requirement of project.
        } catch(Exception ex) {
            System.debug('Motor Web Service Exception::' + ex);
            return ex.getMessage();
        }
        
    }
    
    //Creating signature used in shared authentication
    private static string getSignature(MotorWebRequest request, Long epoch) {
        String toSign = request.publicKey + '\n' + request.method + '\n' + epoch + '\n' + request.encodedUri;        
        Blob hash = crypto.generateMac(request.algoName, Blob.valueOf(toSign), Blob.valueOf(request.privateKey));
        return EncodingUtil.base64Encode(hash);
    }
    
    //Sample request to get the years
    //Execute the code from the anonymous window
    public static string execute(MotorWebRequest motorRequest) {
        //You can add some logic or can perform additional validation before making a request.        
        return MotorWebService.invoke(motorRequest);        
    }
}