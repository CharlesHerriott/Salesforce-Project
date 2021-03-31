public class ExpenseInvController {
	
    private final Invoice_Line_Item__c expenseInvoice;
    public id currentId;
    public ExpenseInvController(ApexPages.standardController std){
         CurrentId = std.getRecord().Id;
    }

    public List<Invoice_Line_Item__c> getILIListwithMileage(){
        List<Invoice_Line_Item__c> ILIList = [SELECT Id, Date__c, Distance__c, 
                                                Hourly_Rate__c, Hours__c, Name, 
                                                RecordTypeId,Amount_del__c, Total_Amount_del__C, Mileage_Cost__c, Mileage_Rate__c, Description__c, ServiceandExpenseInvoiceMDR__c 
                                                FROM Invoice_Line_Item__c WHERE ServiceandExpenseInvoiceMDR__c =:currentId];

        List<Invoice_Line_Item__c> newList = new List<Invoice_Line_Item__c>();
        for(Invoice_Line_Item__c i : ILIList){
            system.debug(i.distance__C);
            if(i.distance__c != null){
                
                newList.add(i);
            }
        }
        
        return newList;
    }

    public List<Invoice_Line_Item__c> getILIListwithoutMileage(){
        List<Invoice_Line_Item__c> ILIList = [SELECT Id, Date__c, Distance__c, 
                                                Hourly_Rate__c, Hours__c, Name, 
                                                RecordTypeId,Amount_del__c, Total_Amount_del__C, Mileage_Cost__c, Mileage_Rate__c, Description__c, ServiceandExpenseInvoiceMDR__c 
                                                FROM Invoice_Line_Item__c WHERE ServiceandExpenseInvoiceMDR__c =: CurrentId];
        
        List<Invoice_Line_Item__c> newList = new List<Invoice_Line_Item__c>();
        for(Invoice_Line_Item__c i : ILIList){
            system.debug(i.distance__C);
            if(i.distance__c == null){
                
                newList.add(i);
            }
        }
        
        return newList;
    }



    public Pagereference saveInvoiceAsPdf(){
        Pagereference pdf = Page.ExpenseInvoiceTOPDF;
        pdf.getParameters().put('id', currentId);

        Attachment attach = new Attachment();

        Blob body;

        try {
            body = pdf.getContent();

        } catch (VisualforceException e ){
            body = Blob.valueOf('some text');
        }

        attach.Body = body;
        Course_nvoices__c course = [SELECT Name FROM Course_nvoices__C WHERE Id=:currentId];
        attach.Name = course.name;
        attach.IsPrivate = false;

        attach.ParentId = currentId;

        insert attach;

        return null;
    }
     
}