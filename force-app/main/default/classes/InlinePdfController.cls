public class InlinePdfController {

    public Boolean attachmentExists {get; set; }
    public Boolean contentPdf {get; set; }
    public Id attachmentId {get; set; }

    public InlinePDFController(ApexPages.StandardController standardController) {
        Id accountId = standardController.getId();
        List<Attachment> attachments = [SELECT Id, Name, ContentType, ParentId 
                                        FROM Attachment
                                        WHERE ParentId = :'a012800000SdK3iAAF'
                                        AND Name like '%test%'
                                        ORDER BY LastModifiedDate DESC];
        attachmentExists = false;
        contentPdf = false;
        if(attachments.size() > 0) {
            attachmentExists = true;
            Attachment a = attachments[0];
            if(a.ContentType != null && ((a.ContentType.toLowerCase().indexOf('pdf') > -1)) || (a.Name.toLowerCase().endsWith('.pdf')))
               {contentPdf = true;}
            attachmentId = a.Id;
        }
    }
    
}