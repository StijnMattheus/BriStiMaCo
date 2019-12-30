codeunit 50100 "BriStiMaCo Functions"
{
    Permissions = tabledata 17 = rimd, tabledata 21 = rimd, tabledata 254 = rimd, tabledata 379 = rimd, tabledata 5802 = rimd, tabledata 112 = rimd;

    procedure ChangePostingDate(var SalesInvoiceHeader: record "Sales Invoice Header")
    var
        PaymentTerms: record "Payment Terms";
        GLEntry: record "G/L Entry";
        VATEntry: record "VAT Entry";
        CustLedgerEntry: record "Cust. Ledger Entry";
        DetailedCustLedgEntry: record "Detailed Cust. Ledg. Entry";
        ValueEntry: record "Value Entry";
        newDueDate: Date;
    begin
        if not confirm(strsubstno('De boekingsdatum zal worden aangepast naar %1', WorkDate())) then
            exit;

        PaymentTerms.reset();
        PaymentTerms.get(SalesInvoiceHeader."Payment Terms Code");
        newDueDate := calcdate(PaymentTerms."Due Date Calculation", WorkDate());

        SalesInvoiceHeader."Posting Date" := WorkDate();
        SalesInvoiceHeader."Due Date" := newDueDate;
        SalesInvoiceHeader.modify();

        GLEntry.Reset();
        GLEntry.setrange("Document Type", GLEntry."Document Type"::Invoice);
        GLEntry.SetRange("Document No.", SalesInvoiceHeader."No.");
        GLEntry.modifyall("Posting Date", SalesInvoiceHeader."Posting Date");

        VATEntry.reset();
        VATEntry.setrange("Document Type", VATEntry."Document Type"::Invoice);
        VATEntry.setrange("Document No.", SalesInvoiceHeader."No.");
        VATEntry.ModifyAll("Posting Date", SalesInvoiceHeader."Posting Date");

        CustLedgerEntry.reset();
        CustLedgerEntry.setrange("Document Type", CustLedgerEntry."Document Type"::Invoice);
        CustLedgerEntry.setrange("Document No.", SalesInvoiceHeader."No.");
        CustLedgerEntry.Modifyall("Posting Date", SalesInvoiceHeader."Posting Date");
        CustLedgerEntry.ModifyAll("Pmt. Discount Date", SalesInvoiceHeader."Posting Date");
        CustLedgerEntry.ModifyAll("Pmt. Disc. Tolerance Date", SalesInvoiceHeader."Posting Date");
        CustLedgerEntry.ModifyAll("Due Date", newDueDate);

        DetailedCustLedgEntry.reset();
        DetailedCustLedgEntry.setrange("Document Type", DetailedCustLedgEntry."Document Type"::Invoice);
        DetailedCustLedgEntry.SetRange("Document No.", SalesInvoiceHeader."No.");
        DetailedCustLedgEntry.setrange("Entry Type", DetailedCustLedgEntry."Entry Type"::"Initial Entry");
        DetailedCustLedgEntry.ModifyAll("Posting Date", SalesInvoiceHeader."Posting Date");
        DetailedCustLedgEntry.ModifyAll("Initial Entry Due Date", newDueDate);

        ValueEntry.Reset();
        ValueEntry.setrange("Document Type", ValueEntry."Document Type"::"Sales Invoice");
        ValueEntry.SetRange("Document No.", SalesInvoiceHeader."No.");
        ValueEntry.ModifyAll("Posting Date", SalesInvoiceHeader."Posting Date");
    end;
}