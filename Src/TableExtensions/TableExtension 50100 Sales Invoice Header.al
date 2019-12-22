tableextension 50100 "Sales Invoice Header" extends "Sales Invoice Header"
{
    procedure ChangePostingDate()
    var
        BriStiMaCoFunctions: Codeunit "BriStiMaCo Functions";
    begin
        clear(BriStiMaCoFunctions);
        BriStiMaCoFunctions.ChangePostingDate(rec);
    end;
}