trigger CourseOpportunityTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after delete) {
        
    if (trigger.isBefore){
        if(trigger.isInsert){
            updateOpportunityName.updateOppName(Trigger.new);
        }
        else if(trigger.isUpdate){
            
        }
        else if(trigger.isDelete){
            
        }
    } else if(trigger.isAfter) {
        if(trigger.isInsert){        
            InstructorNotificationEmailHandler.sendEmail(Trigger.new, 'Create');                  
            InstructorCalendarEventHandler.addCalendarEvent(Trigger.new);
            InstructorInvoiceHandler.createServiceInvoice(Trigger.new);
            AutomateManualShareHandler.ShareOpportunities(Trigger.new);
        }
        else if(trigger.isUpdate){
            InstructorCalendarEventHandler.removeCalendarEvent(Trigger.new);
            InstructorCalendarEventHandler.updateCalendarEvent(Trigger.new);            
            InstructorNotificationEmailHandler.sendEmail(Trigger.new, 'cancel');
            InstructorInvoiceHandler.createServiceInvoice(Trigger.new, Trigger.old);
           
        }
        else if(trigger.isDelete){
           
        }                   
    }
}


