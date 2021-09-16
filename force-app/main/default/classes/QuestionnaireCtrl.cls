public class QuestionnaireCtrl {
    @Auraenabled
    public static wrapperClass getQuestions() {
        set<ID> quesId = new set<ID>();
        list<Questions__c> quesList = new list<Questions__c>();
        wrapperClass wc = new wrapperClass();
        wc.quespaper = [Select Id, Name, Description__c, Division__c,Section1__c,Section2__c,Section3__c,Section4__c, (Select Id,name,Question__c, Section__c, Answer_Type__c From Questions__r order by Section__c, createddate) From Question_Paper__c Limit 1];
        for(Questions__c ques : wc.quespaper.Questions__r ) {
            quesId.add(ques.Id);
        }
        wc.quesList = [Select Id, (Select Id, Name From Answers__r order by createddate) From Questions__c where Id IN: quesId];
        return wc;
    }
    
    @Auraenabled
    public static questionPaper fetchQuestions() {
        
        set<ID> quesId = new set<ID>();
        questionPaper qpaper = new questionPaper();
            
        qpaper.quespaper = [Select Id, Name, Description__c, Division__c,Section1__c,Section2__c,Section3__c,Section4__c, (Select Id,name,Question__c, Section__c, Answer_Type__c From Questions__r order by Section__c, createddate) From Question_Paper__c Limit 1];
         qpaper.questions = new list<question>();
        for(Questions__c ques : qpaper.quespaper.Questions__r ) {
            quesId.add(ques.Id);
        }
        
        map<Id,Questions__c> quesList =  new map<Id,Questions__c>([Select Id, (Select Id, Name From Answers__r order by createddate) From Questions__c where Id IN: quesId]);
        
        for(Questions__c quesTemp : qpaper.quespaper.Questions__r) {
            question qWrap = new question();
            qWrap.question = quesTemp;
            qWrap.isValid = false;
            qWrap.answers = quesList.get(quesTemp.Id).Answers__r;
            
            if(quesTemp.Answer_Type__c == 'Radio' || quesTemp.Answer_Type__c == 'Multiselect') {
                qWrap.format = setRadioFormat(quesList.get(quesTemp.Id).Answers__r);
            }
            
            qpaper.questions.add(qWrap);
        }
        system.debug('qpaper::'+qpaper);
        return qpaper;
    }
    
    public static list<labelValuePair> setRadioFormat(list<Answers__c> answers) {        
        list<labelValuePair> lvList = new list<labelValuePair>();
        for(Answers__c ansTemp : answers) {
            labelValuePair tempObj = new labelValuePair();
            tempObj.label = ansTemp.Name;
            tempObj.value = ansTemp.Id;
            lvList.add(tempObj);
        }
        return lvList;
    }
    
    public class labelValuePair {
        @AuraEnabled public string label{get;set;}
        @AuraEnabled public string value{get;set;}
    }
    
    public class wrapperClass {
        @AuraEnabled public Question_Paper__c quespaper{get;set;}
        @AuraEnabled public list<Questions__c> quesList{get;set;}
    }
    
    public class questionPaper {
        @AuraEnabled public Question_Paper__c quespaper{get;set;}
        @AuraEnabled public list<question> questions{get;set;}
    }
    
    public class question {
        @AuraEnabled public Questions__c question{get;set;}
        @AuraEnabled public boolean isValid{get;set;}
        @AuraEnabled public list<Answers__c> answers{get;set;}
        @AuraEnabled public list<labelValuePair> format{get;set;}
        @AuraEnabled public string correctAnswer{get;set;}
    }
    
}