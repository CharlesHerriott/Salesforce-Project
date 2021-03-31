@isTest
public with sharing class PDFEmailController_Test {

        static Account account;

        static {

            account = new Account();
            account.Name = 'Test Account';
            insert account;

        }
      static testMethod void testPdfEmailer() {

        PageReference pref = Page.ExpenseInvoiceToPDF;
        pref.getParameters().put('id',account.id);
        Test.setCurrentPage(pref);

        PdfEmailController con = new PdfEmailController();

        Test.startTest();

        // populate the field with values
        con.accountId = account.id;
        con.email = 'test@noemail.com';
        // submit the record
        pref = con.sendPdf();
        Integer actualLimits = Limits.getEmailInvocations();
        Test.stopTest(); 


        System.assertEquals(1, actualLimits, 'wrong limits before');

      }

      static testMethod void testPdfEmailerServiceInvoice() {

        PageReference pref = Page.InvoiceToPDF;
        pref.getParameters().put('id',account.id);
        Test.setCurrentPage(pref);

        PdfEmailController con = new PdfEmailController();

        Test.startTest();

        // populate the field with values
        con.accountId = account.id;
        con.email = 'test@noemail.com';
        // submit the record
        pref = con.sendPdf();
        Integer actualLimits = Limits.getEmailInvocations();
        Test.stopTest(); 


        System.assertEquals(1, actualLimits, 'wrong limits before');

      }

    }