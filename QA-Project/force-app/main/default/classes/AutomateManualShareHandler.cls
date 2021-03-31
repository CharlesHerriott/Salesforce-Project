public with sharing class AutomateManualShareHandler {
    public static void ShareOpportunities(List<Opportunity> coursesToShare) {
        List<OpportunityShare> opportList = new List<OpportunityShare>();
        OpportunityShare oppShare;

        for (Opportunity opp : coursesToShare)
        {
            oppShare = new OpportunityShare();
            oppShare.OpportunityId = opp.Id;
            oppShare.UserOrGroupId = opp.Instructor__c;
            oppShare.OpportunityAccessLevel = 'edit';

            opportList.add(oppShare);
        }

        Database.SaveResult[] lsr = Database.insert(opportList, false);
        Integer i =0;

        
    }
}
