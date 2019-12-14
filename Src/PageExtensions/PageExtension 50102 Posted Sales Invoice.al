pageextension 50102 "Posted Sales Invoice" extends "Posted Sales Invoice"
{
    layout
    {
        modify("Sell-to Contact")
        {
            Importance = Additional;
        }
        modify("Currency Code")
        {
            Importance = Additional;
        }        
        modify("EU 3-Party Trade")
        {
            Importance = Additional;
        }
        modify("Shortcut Dimension 1 Code")
        {         
            Importance = Additional;    
        }
        modify("Shortcut Dimension 2 Code")
        {
            Importance = Additional;
        }
        modify("Payment Discount %")
        {
            Importance = Additional;
        }
        modify("Direct Debit Mandate ID")
        {
            Importance = Additional;
        }
        modify("Foreign Trade")
        {
            Visible =false;
        }
    }
}