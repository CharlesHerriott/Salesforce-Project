trigger ServiceInvoiceTrigger on Course_nvoices__c (before insert, after insert, before update, after update, before delete, after delete) {
    if (trigger.isBefore){
        
    } else if(trigger.isAfter) {
        if(trigger.isInsert){        
            ServiceInvoiceLineItemHandler.createServiceInvoiceLineItem(Trigger.new);
        }
        else if(trigger.isUpdate){
            InvoiceTriggerHandler.NotifyBillingAdministrator(Trigger.new, Trigger.old);
        }
                           
    }
}