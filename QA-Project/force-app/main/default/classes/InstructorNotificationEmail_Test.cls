@isTest
public with sharing class InstructorNotificationEmail_Test {
    
    @testSetup
        private static void testSetupObjectDataFactory() {
    
            List<Opportunity> oppList = new List<Opportunity>();
            //for(Integer i =0; i < 201; i++){
                      
                    Opportunity opp = new Opportunity(StageName='Scheduled',Name='Test Company Ltd', Start_Date__c =Date.newInstance(Date.today().year(), 9, 1),
                    CloseDate= Date.newInstance(Date.today().year(), 9, 3), Course_Name__c='a014L000001k4jeQAA', OwnerId='0054L0000013S7hQAE', Instructor__c='0054L0000013UInQAM');
                    oppList.add(opp);
                
                
            //}
            insert oppList;
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User u = [SELECT Id FROM User WHERE profileId = :p.Id LIMIT 1];
            System.runAs(u){
        }
    }
    
    
    @isTest
    public static void InstructorEmailFromOpportunitiesCreate_Test() {

        List<Opportunity> oppList = [SELECT Id, StageName,Name,Start_Date__c,CloseDate,OwnerId,Course_Name__c,Instructor__c FROM Opportunity ];

        Test.startTest();
                       
        InstructorNotificationEmailHandler.SendEmail(oppList, 'created');
                
        Integer actualLimits = Limits.getEmailInvocations();
        Test.stopTest(); 

        
        System.assertEquals(1, actualLimits, 'wrong limits before');
    }

    @isTest
    public static void InstructorEmailFromOpportunitiesUpdate_Test() {

        List<Opportunity> oppList = [SELECT Id, StageName,Name,Start_Date__c,CloseDate,OwnerId,Course_Name__c,Instructor__c FROM Opportunity ];

        Test.startTest();
                       
        InstructorNotificationEmailHandler.SendEmail(oppList, 'update');
                
        Integer actualLimits = Limits.getEmailInvocations();
        Test.stopTest(); 

        
        System.assertEquals(1, actualLimits, 'wrong limits before');
    }

    @isTest
    public static void InstructorEmailFromOpportunitiesDelete_Test() {

        List<Opportunity> oppList = [SELECT Id, StageName,Name,Start_Date__c,CloseDate,OwnerId,Course_Name__c,Instructor__c FROM Opportunity ];

        Test.startTest();
                       
        InstructorNotificationEmailHandler.SendEmail(oppList, 'delete');
                
        Integer actualLimits = Limits.getEmailInvocations();
        Test.stopTest(); 

        
        System.assertEquals(1, actualLimits, 'wrong limits before');
    }
}
