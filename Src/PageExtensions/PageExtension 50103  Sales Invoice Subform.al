pageextension 50103 "Posted Sales Invoice Subform" extends "Posted Sales Invoice Subform"
{
    layout
    {
        modify("Tax Area Code")
        {
            Visible = false;
        }
        modify("Tax Group Code")
        {
            Visible = false;
        }
        modify("Invoice Discount Amount")
        {
            Visible = false;
        }
        modify("Deferral Code")
        {
            Visible = false;
        }
    }
}