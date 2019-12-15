report 50100 "BriStiMaCo Sales Invoice"
{
    Caption = 'BriStiMaCo Sales Invoice';
    DefaultLayout = RDLC;
    RDLCLayout = 'Src/Reports/RDLC/Report 50100 BriStiMaCo Sales Invoice.rdl';

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            DataItemTableView = sorting("Primary Key");

            column(Company_Picture; Picture)
            { }
            column(Company_Name; Name)
            { }
            column(Company_Address; Address)
            { }
            column(Company_PostCodeAndCity; strsubstno('%1 %2', "Company Information"."Post Code", "Company Information".City))
            { }
            column(Company_EMail; "E-Mail")
            { }
            column(Company_HomePage; "Home Page")
            { }
            column(Company_PhoneNo; "Phone No.")
            { }
            column(Company_EnterpriseNo; "Enterprise No.")
            { }
            column(Company_RPR; 'RPR Kortrijk')
            { }

            trigger OnAfterGetRecord()
            begin
                calcfields(Picture);
            end;
        }
        dataitem(Document; "Sales Invoice Header")
        {
            column(Document_No; "No.")
            { }
            column(Document_PostingDate; "Posting Date")
            { }
            column(Document_DueDate; "Due Date")
            { }
            column(Document_YourReference; "Your Reference")
            { }
            column(Document_PaymentTerms; ReturnPaymentTermstext("Payment Terms Code"))
            { }
            column(Document_BilltoName; "Bill-to Name")
            { }
            column(Document_BilltoAddress; "Bill-to Address")
            { }
            column(Document_BillToPostCodeAndCity; strsubstno('%1 %2', "Bill-to Post Code", "Bill-to City"))
            { }
            column(Document_BillToEnterpriseNo; ReturnEnterpriseNo("Bill-to Customer No."))
            { }
            column(Document_AmountExclVAT; ReturnAmountExclVAT(Document))
            { }
            column(Document_AmountInclVAT; ReturnAmountInclVAT(Document))
            { }
            column(Document_VATAmount; ReturnVATAmount(Document))
            { }

            dataitem(Lines; "Sales Invoice Line")
            {
                DataItemLinkReference = document;
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("document no.", "Line No.");

                column(Lines_LineNo; "Line No.")
                { }
                column(Lines_Comment; ReturnCommentLine(Lines))
                { }
                column(Lines_No; "No.")
                { }
                column(Lines_Description; Description)
                { }
                column(Lines_Quantity; Quantity)
                { }
                column(Lines_UnitofMeasure; "Unit of Measure")
                { }
                column(Lines_UnitPrice; "Unit Price")
                { }
                column(Lines_AmountExclVAT; GetLineAmountExclVAT())
                { }
            }
        }
    }

    local procedure ReturnPaymentTermsText(PaymentTermsCode: code[20]): Text
    var
        PaymentTerms: record "Payment Terms";
    begin
        PaymentTerms.Reset();
        PaymentTerms.get(PaymentTermsCode);
        exit(PaymentTerms.Description);
    end;

    local procedure ReturnEnterpriseNo(CustomerNo: code[20]): Text
    var
        Customer: record Customer;
    begin
        Customer.reset();
        Customer.get(CustomerNo);
        if Customer."Enterprise No." <> '' then
            exit(Customer."Enterprise No.")
        else
            exit(customer."VAT Registration No.");
    end;

    local procedure ReturnAmountExclVAT(SalesInvoiceHeader: record "Sales Invoice Header"): Decimal
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        ReturnValue: Decimal;
    begin
        ReturnValue := 0;
        if GetInvoiceLines(SalesInvoiceHeader, SalesInvoiceLine) then
            repeat
                ReturnValue += SalesInvoiceLine.GetLineAmountExclVAT();
            until SalesInvoiceLine.Next() = 0;
        exit(ReturnValue);
    end;

    local procedure ReturnAmountInclVAT(SalesInvoiceHeader: record "Sales Invoice Header"): Decimal
    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        ReturnValue: Decimal;
    begin
        ReturnValue := 0;
        if GetInvoiceLines(SalesInvoiceHeader, SalesInvoiceLine) then
            repeat
                ReturnValue += SalesInvoiceLine.GetLineAmountInclVAT();
            until SalesInvoiceLine.Next() = 0;
        exit(ReturnValue);
    end;

    local procedure ReturnVATAmount(SalesInvoiceHeader: record "Sales Invoice Header"): Decimal
    begin
        exit(ReturnAmountInclVAT(SalesInvoiceHeader) - ReturnAmountExclVAT(SalesInvoiceHeader));
    end;

    local procedure GetInvoiceLines(SalesInvoiceHeader: record "Sales Invoice Header"; var SalesInvoiceLine: record "Sales Invoice Line"): Boolean
    begin
        SalesInvoiceLine.Reset();
        SalesInvoiceLine.setrange("Document No.", SalesInvoiceHeader."No.");
        exit(SalesInvoiceLine.findset());
    end;

    local procedure ReturnCommentLine(SalesInvoiceLine: Record "Sales Invoice Line"): Integer
    begin
        if (SalesInvoiceLine."No." = '') then
            exit(1);
        exit(0);
    end;
}