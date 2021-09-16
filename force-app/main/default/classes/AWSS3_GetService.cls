public class AWSS3_GetService extends AWS {
    public override void init() {
        endpoint = new Url('https://integrationbgi.s3.ap-south-1.amazonaws.com');
        resource = '/Capture.PNG';
        region = 'ap-south-1';
        service = 's3';
        accessKey = 'AKIAIQ2YWKLYLQDOS7CQ';
        method = HttpMethod.XGET;
        //	Remember to set "payload" here if you need to specify a body
        //	payload = Blob.valueOf('some-text-i-want-to-send');
        //  This method helps prevent leaking secret key, 
        //  as it is never serialized
        createSigningKey('SSdA5QaWh5R/GMUG7iYlDXGxElwoXrOamdm2kWQA');
    }
    public String[] getBuckets() {
        HttpResponse response = sendRequest();
        Attachment attach = new Attachment();
                
        attach.Body = blob.valueOf(response.getBody());
        // add the user entered name
        attach.Name = 'test';
        attach.IsPrivate = false;
        attach.ContentType = 'image/png';
        // attach the pdf to the account
        attach.ParentId = '0030K00001UeXu0';
        insert attach;
        
        String[] results = new String[0];
        // Read response XML; if we get this far, no exception happened
        // This code was omitted for brevity
        return results;
    }
}