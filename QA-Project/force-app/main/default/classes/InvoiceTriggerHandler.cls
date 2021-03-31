public class InvoiceTriggerHandler {
    
    public static void UpdateAutoNumbers(List<Course_nvoices__c> courseInvoices){
        AutoNumber__c[] Index = [SELECT  Service_Invoice_Index__c, Expense_Invoice_Index__c FROM AutoNumber__c];
        
        List<Autonumber__c> increment = [SELECT Service_Invoice_Index__c, Expense_Invoice_Index__c FROM AutoNumber__c];
        List<Autonumber__c> toUpdate = new List<Autonumber__c>();
        
        String ServiceRecordType = Schema.SObjectType.Course_nvoices__c.getRecordTypeInfosByName().get('Service Invoice').getRecordTypeId();
        String ExpenseRecordType = Schema.SObjectType.Course_nvoices__c.getRecordTypeInfosByName().get('Expense Invoice').getRecordTypeId();
        
        for (Course_nvoices__c a : courseInvoices){
            
            if(a.RecordTypeId == ServiceRecordType){
                
                Decimal toInt = Index[0].Service_Invoice_Index__c.intValue();
                String toString = toInt.toPlainString();
                Integer size = toString.length();            
                Integer addZeros = 4 - size;            
                String placeHolder = '';
                
                for(Integer i = 0; i < addZeros; i++){
                    placeHolder += '0';
                }
                
                a.Name = 'INV-{'+ placeHolder + Index[0].Service_Invoice_Index__c + '}';
                AutoNumber__c test = increment[0];
                test.Service_Invoice_Index__c += 1;
                toUpdate.add(test);
            }
            
            else if(a.RecordTypeId == ExpenseRecordType){
                
                Decimal toInt = Index[0].Expense_Invoice_Index__c.intValue();
                String toString = toInt.toPlainString();
                Integer size = toString.length();            
                Integer addZeros = 4 - size;            
                String placeHolder = '';
                
                for(Integer i = 0; i < addZeros; i++){
                    placeHolder += '0';
                }
                
                a.Name = 'EXPINV-{' + placeHolder + Index[0].Expense_Invoice_Index__c + '}';
                AutoNumber__c test = increment[0];
                test.Expense_Invoice_Index__c += 1;
                toUpdate.add(test);
                
                
            }
        }

        Set<AutoNumber__c> toSet = new Set<AutoNumber__c>();
        List<Autonumber__c> toList = new List<Autonumber__c>();
        toSet.addAll(toupdate);
        toList.addall(toSet);
        update toList;
    }


    public static void NotifyBillingAdministrator(List<Course_nvoices__c> invoices, List<Course_nvoices__c> oldInvoices){


        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

        Set<id> contactID = new set<id>();
        Set<id> invoiceId = new set<id>(); 

        List<Opportunity> opps = [SELECT Id FROM Opportunity];

        User u = [SELECT Id, Name, email FROM User WHERE Name ='Charles Herriott'];
        Integer i = 0;
        
        for(Course_nvoices__c cInv : invoices){
            if(cInv.Invoice_Status__c == 'Submitted' 
                && oldInvoices[i].Invoice_Status__c != 'Submitted'){
               
                
                // Course_nvoices__c invoice = [SELECT Id FROM Course_nvoices__c WHERE Id =: ContactId];

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                Attachment attach = new Attachment();

                
                // sendTo.add(u.email);

                // mail.setToAddresses(sendTo);

                String sendTo = u.id;
                mail.setTargetObjectId(sendTo);
                mail.setTreatTargetObjectAsRecipient(true);
                mail.saveAsActivity = false;

                mail.setReplyTo('Cherriott@qa.com');
                mail.setSenderDisplayName('Billing Administrator');

                mail.setSubject('Invoice Submitted');
                String body = 'Dear ' + u.Name + ' The invoice: ' + cInv.Name + 'Has been submitted';
                System.debug(U.name);
                mail.setHtmlBody(body); 
                
                
                mails.add(mail);

            }
            i++;
        }
       // Messaging.SendEmailResult[] results = Messaging.sendEmail(mails, false);
    }

}
