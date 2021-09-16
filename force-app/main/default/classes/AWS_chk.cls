public class AWS_chk {
    
    public void run() {
        Attachment attach = [
            select Body,
            ContentType,
            Name
            from Attachment
            limit 1
        ];
        
        String attachmentBody = EncodingUtil.base64Encode(attach.Body);
        DateTime formattedDateString = Datetime.now();
        String key = 'AKIAIQ2YWKLYLQDOS7CQ';
        String secret =  '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';
        String bucketname = 'integrationbgi';
        String host = 's3-ap-south-1.amazonaws.com';
        String method = 'PUT';
        String filename = attach.Id + '-' + attach.Name;
        
        HttpRequest req = new HttpRequest();
        req.setMethod(method);
        req.setEndpoint('https://' + bucketname + '.' + host + '/' + bucketname + '/' + filename);
        req.setHeader('Host', bucketname + '.' + host);
        req.setHeader('Content-Length', String.valueOf(attachmentBody.length()));
        req.setHeader('Content-Encoding', 'UTF-8');
        req.setHeader('Content-type', attach.ContentType);
        req.setHeader('Connection', 'keep-alive');
        req.setHeader('X-Amz-Date', formattedDateString.formatGMT('E, dd MMM yyyy HH:mm:ss z'));
        req.setHeader('ACL', 'public-read');
        req.setHeader('x-amz-content-sha256', 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855');
        req.setBody(attachmentBody);
        system.debug('attach.ContentType::' + attach.ContentType );
        String stringToSign = 'PUT\n\n' +
            attach.ContentType + '\n' +
            formattedDateString.formatGMT('E, dd MMM yyyy HH:mm:ss z') + '\n' + 'host;user-agent;x-amz-content-sha256;x-amz-date' +
            '/' + bucketname + '/'  + filename;
        
        //String encodedStringToSign = EncodingUtil.urlEncode(stringToSign, 'UTF-8');
        Blob mac = Crypto.generateMac('hmacSHA256', blob.valueof(stringToSign),blob.valueof(secret));
        String signed = EncodingUtil.base64Encode(mac);
        String authHeader = 'AWS4-HMAC-SHA256' + ' ' + key + ':' + signed;
        req.setHeader('Authorization','AWS4-HMAC-SHA256 Credential=AKIAIQ2YWKLYLQDOS7CQ/'+formattedDateString.formatGMT('YYYYMMdd')+'/ap-south-1/s3/aws4_request, SignedHeaders=host;user-agent;x-amz-content-sha256;x-amz-date, Signature='+signed);
        //String decoded = EncodingUtil.urlDecode(encodedStringToSign , 'UTF-8');
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('*Resp:' + String.ValueOF(res.getBody()));
        System.debug('RESPONSE STRING: ' + res.toString());
        System.debug('RESPONSE STATUS: ' + res.getStatus());
        System.debug('STATUS_CODE: ' + res.getStatusCode());
    }
}