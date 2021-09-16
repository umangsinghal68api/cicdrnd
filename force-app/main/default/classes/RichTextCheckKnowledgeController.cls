public class RichTextCheckKnowledgeController {
public static Knowledge__kav  data{get;set;}
  public RichTextCheckKnowledgeController() {
  }

  @AuraEnabled
  public static String getknowldgeArticle(){
    data = [ SELECT ID,RichTextContent__c,KnowledgeArticleId
              FROM Knowledge__kav 
              WHERE 
              PublishStatus = 'Online' and Title = 'TestRichText' and Language = 'en_US'
              ];
    System.debug('###data:'+data);
    return JSON.serialize(data);
  }
}