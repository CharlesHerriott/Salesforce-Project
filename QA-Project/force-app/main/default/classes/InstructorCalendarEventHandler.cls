public with sharing class InstructorCalendarEventHandler {

    public static void addCalendarEvent(List<Opportunity> courses){
        List<Event> newCal = new List<Event>();
        Boolean hasEvent = false;
        List<Event> current = [SELECT WhatId FROM event];
        
    
        for(Opportunity opp : courses){
            hasEvent = false;
            for(Integer i = 0; i < current.size(); i++){
                if(current[i].whatId == opp.id){
                    hasEvent = true;
                }
            }
            if(!hasEvent){
                Event ev = new Event();
                ev.StartDateTime = opp.Start_Date__c;
                ev.EndDateTime = opp.CloseDate;
                ev.Subject = opp.Name;
                ev.OwnerId = opp.Instructor__c;
                ev.WhatId = opp.Id;
                ev.Location = opp.Location__c;

                newCal.add(ev);
            }
        }

        insert newCal;
    }

    public static void updateCalendarEvent(List<Opportunity> toUpdate){
        // Instantiate an empty list to add 'toUpdate' items to. Pull in the events.
        List<Event> calToUpdate = new List<Event>();   
        List<Event> evList = [SELECT StartDateTime, EndDateTime, Subject, OwnerId, WhatId, Location FROM Event];
        Integer i = 0;
        // Only run if there are events.
        if(evList.size() > 0 ){
            for(Opportunity opp : toUpdate){
                //If the event is related to the relevant opportunity.
                if(evList[i].whatId == opp.id){                        
                evList[i].StartDateTime = opp.Start_Date__c;
                evList[i].EndDateTime = opp.CloseDate;
                evList[i].Subject = opp.Name;
                evList[i].OwnerId = opp.Instructor__c;
                evList[i].WhatId = opp.Id;
                evList[i].Location = opp.Location__c;
                            
                calToUpdate.add(evList[i]);    
                }
            }
        }
        System.debug(calToUpdate.size());
       // System.debug(ev.size()); // Test if DEV CONSOLE WORKS :D
        if(calToUpdate.size() != 0){
            update calToUpdate;
        
    }
}

    public static void removeCalendarEvent(List<Opportunity> toDel){
       
        List<Event> calEvents = [SELECT OwnerId, Subject, WhatId FROM Event];
        List<Event> calToDelete = new List<Event>();

        for(Opportunity opp : toDel){
            for(Event ev : calEvents){
               if(ev.WhatId == opp.id && opp.StageName.equalsIgnoreCase('Cancelled')){
                  calToDelete.add(ev); 
                }   
             
            }             
        }
        if(calToDelete.size() > 0){
            delete calToDelete;
        }
    }
}

