trigger FormatInvoiceAutoNumbers on Course_nvoices__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
   
    if (trigger.isBefore){
        if(trigger.isInsert){
            InvoiceTriggerHandler.UpdateAutoNumbers(Trigger.New);            
        }
      
    } 
  
}