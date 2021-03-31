public with sharing class updateOpportunityName {
    public static void updateOppName(List<Opportunity> oppList){

        List<User> uList = [SELECT FirstName, LastName FROM User];
        List<Course__c> courseList = [SELECT Name FROM Course__c];
        String userFirstName;
        String userLastName;
        String courseName;
        for(Opportunity opp : oppList){
            for(User u : uList){
                if(u.id == opp.Instructor__c){
                    userFirstName = u.Firstname;
                    userLastName = u.LastName;
                }
            }

            for(Course__c course : courseList){
                if(course.id == opp.Course_Name__c){
                    courseName = course.Name;
                }
            }
            opp.Name = userFirstName +' ' + userLastName + ' - ' + courseName;
            
        }

        
    }
}
