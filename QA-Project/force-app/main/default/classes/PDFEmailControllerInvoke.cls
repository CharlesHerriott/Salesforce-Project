public with sharing class PDFEmailControllerInvoke {

    //allows the expense invoice pdf controller to be invocable.

    Public class FlowInput{
        @InvocableVariable public ID accountId;
    }
    @InvocableMethod(label='Send Expense Invoice' description='')
    public static void PdfEmailControlInvoke(list<FlowInput> request) {


                ID accountID = request[0].accountId;

                PdfEmailController con = new PdfEmailController();

                con.accountId = accountID;
                con.email = 'Charlesherriott@virgimedia.com';
                con.sendPdf();
    }
}