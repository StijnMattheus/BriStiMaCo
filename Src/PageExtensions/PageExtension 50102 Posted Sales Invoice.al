pageextension 50102 "Posted Sales Invoice" extends "Posted Sales Invoice"
{
    actions
    {
        addlast(Correct)
        {
            action(ChangePostingDate)
            {
                Caption = 'Boekingsdatum aanpassen';
                ApplicationArea = all;
                Image = ChangeDate;

                trigger OnAction()
                begin
                    ChangePostingDate();
                end;
            }
        }
    }
}