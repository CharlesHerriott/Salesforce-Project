public class InvoiceControllerExtension {
    public id CurrentId;
    public InvoiceControllerExtension(ApexPages.StandardController controller) {   
        CurrentId = controller.getRecord().Id;

    }

    public List<Invoice_Line_Item__c> getILIList(){
        List<Invoice_Line_Item__c> ILIList = [SELECT Id, Date__c, Distance__c, 
                                                Hourly_Rate__c, Hours__c, Name, 
                                                RecordTypeId,Service_cost__c, service_vat__c, service_total_cost__c, Description__c, ServiceandExpenseInvoiceMDR__c 
                                                FROM Invoice_Line_Item__c WHERE ServiceandExpenseInvoiceMDR__c =: CurrentId];
        
        return ILIList;
    }

}
