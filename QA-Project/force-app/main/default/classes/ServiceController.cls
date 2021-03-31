public class ServiceController {
    private final Invoice_Line_Item__c serviceInvoice;
    String serviceRecId = Schema.SObjectType.Course_nvoices__c.getRecordTypeInfosByName().get('Service Invoice').getRecordTypeId();
    public String currentRecordId {get;set;}
    public String parameterVal {get;set;}
    public Id curRec;
    public Course_nvoices__c idTest {get;set;}
    
    public ServiceController(ApexPages.StandardController stdController) {
        this.serviceInvoice = (Invoice_Line_Item__c)stdController.getRecord();
        idTest = [SELECT Name, Id from Course_nvoices__c WHERE Id = :ApexPages.currentPage().GetParameters().get('Id')];
        System.debug(idTest);
    }
    
    public String getRecordTypeName(String invoice){
        return Schema.SObjectType.Course_nvoices__c.getRecordTypeInfosByName().get(invoice).getRecordTypeId();      
    }
    
    
    List<Invoice_Line_Item__c> rec_query = new List<Invoice_Line_Item__c>();
    public String strSelectRecordOption {get;set;}
    
    public List<SelectOption> getRecordTypeOption(){
        rec_query = [SELECT recordTypeId, Name FROM Invoice_Line_Item__c];
        List<SelectOption> listOptions = new List<SelectOption>();
        for (Invoice_Line_Item__c getRec : rec_query){
            listOptions.add(new SelectOption(getRec.RecordTypeId, 'Expense Label'));
        }
        
        
        /* rec_query = [SELECT recordTypeId, Name FROM Course_nvoices__c];
List<SelectOption> listOptions = new List<SelectOption>();
for (Course_nvoices__C getRec : rec_query){
listOptions.add(new SelectOption(getRec.Name, getRec.recordTypeId));
}*/
        return listOptions;
    }
    
    
    public PageReference NewInvoice() { 
        System.debug('Record Type Name: ' + getRecordTypeName('Service Invoice'));
        List<Course_nvoices__c> cInv = [Select Id, Name, recordTypeId FROM Course_nvoices__c];
        Course_nvoices__c curRec = [SELECT Id, Name FROM Course_nvoices__c limit 1];
        System.debug(ApexPages.currentPage().getParameters().get('Name'));
        System.debug(ApexPages.currentPage().getParameters().get('id'));
        System.debug(idTest);
        
        for(Course_nvoices__c c : cInv){
            System.debug('course invoice recId: '+ c.Id + '  ' + curRec.Id);
            if(c.Id == curRec.Id){
                System.debug('ID match Passed' + curRec.Name);
                System.debug('C.RecordTypeId' + c.RecordTypeId + '   ' + getRecordTypeName('Service Invoice') + '  List size ' + cInv.size());
                if(c.recordTypeId.equals(getRecordTypeName('Service Invoice'))){
                    System.debug('Are these the same?: ' + c.RecordTypeId + ' ' + getRecordTypeName('Service Invoice'));
                    return new PageReference('/apex/CustomInvoiceServiceLineItem');
                } else {
                    return new PageReference('/apex/CustomInvoiceExpenseLineItem');
                }
            } 
        }
        return null;
        
    }
    
}