public with sharing class ServiceInvoiceLineItemHandler {
    public static void createServiceInvoiceLineItem(List<Course_nvoices__c> courseInvoices){
      List<Invoice_Line_Item__c> newILIList = new List<Invoice_Line_Item__c>();
      List<Opportunity> oppList = [SELECT id, Start_Date__c FROM opportunity];
      //system.debug('OppList Size: ' + oppList.size() + 'oppList[0].Start_date__c : ' + oppList[0].Start_Date__c);
      String ServiceRecordType = Schema.SObjectType.Course_nvoices__c.getRecordTypeInfosByName().get('Service Invoice').getRecordTypeId();
      String ExpenseRecordType = Schema.SObjectType.Course_nvoices__c.getRecordTypeInfosByName().get('Expense Invoice').getRecordTypeId();
      String MileageRecordType = Schema.SObjectType.Invoice_Line_Item__c.getRecordTypeInfosByName().get('Mileage').getRecordTypeId();


      Integer day = 0;
      system.debug('create service line item lsit size' + oppList.size());
        for(Course_nvoices__c cInv : courseInvoices){
          System.debug(cInv.location__c);
          System.debug('cInv.recordTypeID: ' + cInv.recordTypeID + ' and expenseRecordType: ' + ExpenseRecordType);
            if(cInv.recordTypeId == ServiceRecordType){
              for(Integer i = 0; i < cInv.duration__c; i++){
                  Invoice_Line_Item__c newILI = new Invoice_Line_Item__c();
                  newILI.ServiceandExpenseInvoiceMDR__c = cInv.Id;
                  newILI.hours__c = 8;
                  newILI.Date__c = oppList[0].Start_Date__c.addDays(i);
                  newILI.Description__c = 'Day of Teaching';
                  newILIList.add(newILI);
                  day++;
              }
            }
            else if(cInv.Location__c != null){
                if(cInv.recordTypeId == ExpenseRecordType ){
                  for(Integer i = 0; i < cInv.Duration__c; i++){
                    for(integer j =0; j < 2; j++){
                      Invoice_Line_Item__c newEILI = new Invoice_Line_Item__c();
                      newEILI.ServiceandExpenseInvoiceMDR__c = cInv.id;
                      newEILI.recordTypeId = MileageRecordType;
                      newEILI.Distance__c = 5;
                      newEILI.mileage_rate__c = 0.42;
                      if(j == 0){
                        newEILI.description__c = 'Travelling To ' + cInv.Location__c;
                      } else {
                        newEILI.description__c = 'Travelling From ' + cInv.Location__c;
                      }
                      
                      newEILI.date__c = oppList[0].Start_Date__c.addDays(i);
                      newILIList.add(newEILI);
                    }
                  }
                }
              }
        }
        insert(newILIList);
    }
}
