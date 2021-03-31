public class InstructorNotificationEmailHandler {

    public static void sendEmail(List<Opportunity> opportunities, String action){
        //Create List of Id's to hold the users and the course opportunity.
        set<id> ContactId = new set<id>();
        set<id> CourseId = new set<id>();

        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        List<Opportunity> courseList = [SELECT CloseDate, Start_Date__c, Name, StageName FROM Opportunity];
        List<User> userList = [SELECT Name, lastName, email FROM User];
        

        for(Opportunity opp : opportunities){
            Opportunity course = new Opportunity();
            User users = new User();
            if(opp.Instructor__c != null){
                ContactId.add(opp.Instructor__c);
                CourseId.add(opp.Id);
            }
            
            for(integer i = 0; i < courseList.size(); i++){
                if(courseList[i].id == opp.Id){
                    course = courseList[i];
                }
                
            }

            for(Integer i = 0; i < userList.size(); i++){
                if(userList[i].id == opp.Instructor__c){
                    users = userList[i];
                }
            }

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            String sendTo = users.id;
            mail.setTargetObjectId(sendTo);
            mail.setTreatTargetObjectAsRecipient(true);
            mail.saveAsActivity = false;

            mail.setReplyTo('Cherriott@qa.com');
            mail.setSenderDisplayName('Billing Administrator');

            mail.setSubject('Course to deliver scheduled');
            String body = '';
            if(action.equalsIgnoreCase('created')){
                body = 'Dear ' + users.Name + '. You have a course scheduled: ' + course.Name +  ' . Starting on :' + course.Start_Date__c + ' Until:' + course.CloseDate;
                mail.setHtmlBody(body);
            }
            else {
                body = 'Dear ' + users.Name + '. The scheduled course: ' + course.Name + ' has been cancelled.';
                mail.setHtmlBody(body);

            }
            
            mails.add(mail);

            
        }
        Messaging.sendEmail(mails);
    }
}

