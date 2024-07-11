codeunit 60554 "Manage Dimension On License"
{
    SingleInstance = true;
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
        G_Caption: Text;


    //Get The Caption (Step1)
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Caption Class", 'OnResolveCaptionClass', '', true, true)]
    local procedure MyOnResolveCaptionClass(CaptionArea: Text; CaptionExpr: Text; Language: Integer; var Caption: Text; var Resolved: Boolean)
    begin
        if CaptionArea = '18' then begin
            Clear(G_Caption);
            Caption := GetCaptionItemAttribute(CaptionExpr);
            G_Caption := GetCaptionItemAttribute(CaptionExpr);
            Resolved := true;
        end;
    end;

    local procedure GetCaptionItemAttribute(CaptionExpr: Text): Text
    var
        FieldNo: Integer;
        Fiedrefrence: FieldRef;
        SetupRecordRef: RecordRef;
    begin
        SetupRecordRef.Open(Database::"General Ledger Setup");
        Evaluate(FieldNo, CaptionExpr);
        If SetupRecordRef.FindFirst() then begin
            Fiedrefrence := SetupRecordRef.Field(FieldNo);
            exit(Fiedrefrence.Value);
        end;
    end;

    //Update Dimension On COmpany License Header (Step2)
    [EventSubscriber(ObjectType::Table, Database::"Company License Header", 'OnAfterValidateEvent', 'Company No.', false, false)]
    local procedure CompanyNo_OnAfterValidateEvent(var Rec: Record "Company License Header")
    var
        L_DefaultDimension: Record "Default Dimension";
    begin
        if Rec."Company Type" = Rec."Company Type"::Customer then begin
            L_DefaultDimension.Reset();
            L_DefaultDimension.SetRange("Table ID", 18);
            L_DefaultDimension.SetRange("No.", Rec."Company No.");
            //L_DefaultDimension.SetRange("Dimension Code", G_Caption);
            L_DefaultDimension.SetRange("Dimension Code", GetCaptionItemAttribute('83'));
            if L_DefaultDimension.FindFirst() then begin
                Rec."Shortcut Dimension 3 Code" := L_DefaultDimension."Dimension Value Code";
            end;
        end;
    end;

}