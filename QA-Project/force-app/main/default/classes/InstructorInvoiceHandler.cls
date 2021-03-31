public with sharing class InstructorInvoiceHandler {

    public static void createServiceInvoice(List<Opportunity> courses, List<Opportunity> oldCourses){
        String ServiceRecordType = Schema.SObjectType.Course_nvoices__c.getRecordTypeInfosByName().get('Service Invoice').getRecordTypeId();
        
        List<Course_nvoices__c> newInvList = new List<Course_nvoices__c>();
        Integer i = 0;
        for(Opportunity opp : courses){
           
            if(opp.StageName == 'Completed' && oldCourses[i].StageName != 'Completed'){
                Course_nvoices__c newInv = new Course_nvoices__c();
                newInv.Course_Opportunity__c = opp.Id;
                newInv.recordTypeId = ServiceRecordType;
                newInvList.add(newInv);                
            }
        
            i++;
        }        
        insert newInvList;
    }

    public static void createServiceInvoice(List<Opportunity> courses){
        String ServiceRecordType = Schema.SObjectType.Course_nvoices__c.getRecordTypeInfosByName().get('Service Invoice').getRecordTypeId();
        
        List<Course_nvoices__c> newInvList = new List<Course_nvoices__c>();
        Integer i = 0;
        for(Opportunity opp : courses){
           
            if(opp.StageName == 'Completed'){
                Course_nvoices__c newInv = new Course_nvoices__c();
                newInv.Course_Opportunity__c = opp.Id;
                newInv.recordTypeId = ServiceRecordType;
                newInvList.add(newInv);                
            }
                  
            i++;
        }        
        insert newInvList;
    }
}
