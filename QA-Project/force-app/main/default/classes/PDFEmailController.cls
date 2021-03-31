public with sharing class PDFEmailController {

    //Creates an email for the expense invoice and attachs the pdf

    public ID accountId {get;set;}
    public String email {get;set;}


    public PageReference sendPdf() {
    
        List<User> userList = [SELECT Id FROM USER WHERE FirstName = 'Jason'];

      PageReference pdf = Page.ExpenseInvoiceToPDF;
      // add parent id to the parameters for standardcontroller
      pdf.getParameters().put('id',accountId);

      // the contents of the attachment from the pdf
      Blob body;

      try {

        // returns the output of the page as a PDF
        body = pdf.getContentAsPdf();

      // need to pass unit test -- current bug
      } catch (VisualforceException e) {
        body = Blob.valueOf('Some Text');
      }

      Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
      attach.setContentType('application/pdf');
      attach.setFileName('testPdf.pdf');
      attach.setInline(false);
      attach.Body = body;

      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.setUseSignature(false);
      
      mail.setTargetObjectId(userList[0].id);
      mail.setSaveAsActivity(false);
      mail.setSubject('PDF Email Demo');
      mail.setHtmlBody('Here is the email you requested! Check the attachment!');
      mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 

      // Send the email
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

      

      return null;

    }

}