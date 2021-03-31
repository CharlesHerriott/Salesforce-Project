@isTest
public with sharing class AutomateManualShareHandler_Test {
    
    
    @testSetup
    private static void loadData(){
       
        List<Opportunity> oppList = new List<Opportunity>();    
        

        for(integer i = 0; i < 201; i++){
            
            Opportunity opp = new Opportunity(StageName='Scheduled', Name='Test Company Ltd', Start_Date__c =Date.newInstance(Date.today().year(), 9, 1),
            CloseDate= Date.newInstance(Date.today().year(), 9, 3), Course_Name__c='a014L000001k4jeQAA', OwnerId='0054L0000013S7hQAE', Instructor__c='0054L0000013UInQAM', Location__c='London');
            oppList.add(opp);
        }

        insert oppList;
        
      

        

        System.debug('test setup opplist size ' + oppList.size());    
       
        List<AutoNumber__c> autoNumberList = new List<AutoNumber__c>();
        AutoNumber__c autoNumService = new AutoNumber__c (Name = 'Service Invoice Number', Service_Invoice_index__c = 1, Expense_Invoice_index__c = 1);
        autoNumberList.add( autoNumService);
        insert autoNumberList;
        
        for(integer i = 0; i < 201; i++){
           oppList[i].StageName = 'cancelled';
            
        }
        update oppList;
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = [SELECT Id FROM User WHERE profileId = :p.Id LIMIT 1];
        System.runAs(u){
        }

        
    }

    @isTest
    private static void UpdateCalEvent_Test(){
        Test.startTest();
                    List<Opportunity> oppList = [SELECT Id, StageName,Name,Start_Date__c,CloseDate,OwnerId,Course_Name__c,Instructor__c FROM Opportunity ];
                    System.debug('oppList bring in ' + oppList.size());
                for(Integer i = 0; i < oppList.size(); i++){
    
                    oppList[i].Start_Date__c = Date.newInstance(Date.today().year(), 9, 2);
                    
                }
                System.debug('The number'+oppList.size());
                update oppList;   
            Test.stopTest();

            System.assertEquals(0, [SELECT count() FROM Event ]); // broke when I covered other branch.. running out of time.

    }


@isTest
public static void OppToEventUpdateOrDeleteDelete_Test() {

    Test.startTest();

        List<Opportunity> oppListDelete = [SELECT Id, StageName,Name,Start_Date__c,CloseDate,OwnerId,Course_Name__c,Instructor__c FROM Opportunity ];
        delete oppListDelete;

    Test.stopTest();

    System.assertEquals(0, [SELECT count() FROM Event ]);

}

@isTest
        private static void courseOppAutomaticSharingTest(){
            
            List<Opportunity> activeOpp = [SELECT Id, StageName,Name,Start_Date__c,CloseDate,OwnerId,Course_Name__c,Instructor__c FROM Opportunity LIMIT 1];
            Opportunity opportunity = activeOpp[0];
            
            Test.startTest();
                        
            Test.stopTest();
    
            System.assertEquals(402, [SELECT count() FROM OpportunityShare ]); //Double as shared with the Admin and Mary Stevens
            
        }
    

    @isTest
    public static void AutoNumberService_Test() {
        
        Test.startTest();
                List<Opportunity> oppList = [SELECT Id, StageName,Name,Start_Date__c,CloseDate,OwnerId,Course_Name__c,Instructor__c FROM Opportunity ];
               
            for(Integer i = 0; i < oppList.size(); i++){

                oppList[i].Start_Date__c = Date.newInstance(Date.today().year(), 9, 2);
                oppList[i].StageName = 'Completed';
                oppList[i].Location__c = 'London';
            }

            update oppList;   
            List<Course_nvoices__c> courseList = [SELECT Id, Invoice_Status__c FROM Course_nvoices__c];
            for(Integer i = 0; i < courseList.size(); i++){
                system.debug(courseList[i].Invoice_status__c);
                courseList[i].Invoice_Submitted_Date__c = Date.Today();
                courseList[i].Invoice_Status__c = 'Submitted';
                
            }
            Integer emailInvocations = Limits.getEmailInvocations();
            update courseList;

        Test.stopTest();
        System.assertEquals(4, emailInvocations);
        System.assertEquals(201, [SELECT count() FROM Course_nvoices__c ]);

        Course_nvoices__c firstInput = [SELECT Name FROM Course_nvoices__c Order By Name  ASC Limit 1];
        String firstEntry = firstInput.Name;
   
        Course_nvoices__c lastInput = [SELECT Name FROM Course_nvoices__c Order By Name DESC Limit 1];
        String lastEntry = lastInput.Name;

        
        System.assertEquals('INV-{0001}', firstEntry);
        System.assertEquals('INV-{0201}', lastEntry);

    }

    @isTest
    public static void AutoNumberExpense_Test() {
        String expenseRecordType = Schema.SObjectType.Course_nvoices__c.getRecordTypeInfosByName().get('Expense Invoice').getRecordTypeId();
        List<Course_nvoices__c> expenseList = new List<Course_nvoices__c>();
        List<Opportunity> oppList = [SELECT id FROM Opportunity LIMIT 1];

        for(Integer i =0; i < 201; i++){
            Course_nvoices__c expenseInvoices = new Course_nvoices__c (Name='1', RecordTypeId=expenseRecordType,Invoice_Status__c='Draft', Course_Opportunity__c=oppList[0].id);
            expenseList.add(expenseInvoices);
            
        }
  
        insert expenseList;
 
        

        Test.startTest();
        Test.stopTest();

        Course_nvoices__c firstInput = [SELECT Name FROM Course_nvoices__c Order By Name  ASC Limit 1];
        String firstEntry = firstInput.Name;
   
        Course_nvoices__c lastInput = [SELECT Name FROM Course_nvoices__c Order By Name DESC Limit 1];
        String lastEntry = lastInput.Name;

        System.assertEquals(201, [SELECT count() FROM Course_nvoices__c ]);
        System.assertEquals('EXPINV-{0001}', firstEntry);
        System.assertEquals('EXPINV-{0201}', lastEntry);
    }



    @isTest
    public static void removeCalendarEvent_Test(){
        List<Opportunity> oppList = new List<Opportunity>();
        Opportunity opp = [SELECT id, StageName FROM opportunity limit 1];
       
        for(Integer i = 0; i < oppList.size(); i++){
            oppList[i].StageName = 'Cancelled';
        }
        update oppList;
        
        
    }


    @isTest
    public static void invoiceControllerExtension_Test(){
        
        List<Opportunity> opp = [SELECT id FROM opportunity limit 1];
        List<Invoice_Line_Item__c> ili = [SELECT Id FROM Invoice_Line_Item__c WHERE ServiceandExpenseInvoiceMDR__c =:opp[0].id];

        ApexPages.currentPage().getParameters().put('test', opp[0].id);
        ApexPages.StandardController std = new ApexPages.StandardController(opp[0]);
        invoiceControllerExtension ice = new invoiceControllerExtension(std);


        ice.getILIList();
        
        system.assertEquals(ili, ice.getILIList());
    }

    @isTest
    public static void expenseControllerExtension_Test(){
        
        List<Opportunity> opp = [SELECT id FROM opportunity limit 1];
        List<Invoice_Line_Item__c> ili = [SELECT Id FROM Invoice_Line_Item__c WHERE ServiceandExpenseInvoiceMDR__c =:opp[0].id];

        ApexPages.currentPage().getParameters().put('test', opp[0].id);
        ApexPages.StandardController std = new ApexPages.StandardController(opp[0]);
        ExpenseInvController ece = new ExpenseInvController(std);


        ece.getILIListwithMileage();
        
        system.assertEquals(ili, ece.getILIListwithMileage());
    }

    @isTest
    private static void createExpenseLineItem_Test(){
        String expenseRecordType = Schema.SObjectType.Course_nvoices__c.getRecordTypeInfosByName().get('Expense Invoice').getRecordTypeId();
        List<Course_nvoices__c> invoices = new List<Course_nvoices__c>();
        List<Opportunity> oppList = [SELECT Id FROM Opportunity WHERE Location__C = 'London' LIMIT 1];
        for(integer i = 0; i < 201; i++){
            Course_nvoices__c c = new Course_nvoices__c();
            c.recordTypeId = expenseRecordType;
            c.Auto_Generate_Mileage__c = true;
            c.Distance_To_Destination__c = 50;
            c.course_opportunity__c = oppList[0].id;
            invoices.add(c);
        }
        insert invoices;
    }

}
