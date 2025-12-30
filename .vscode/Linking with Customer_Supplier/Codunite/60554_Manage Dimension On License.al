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


    //Modify Dimension on Company License Header when Dimension code is changed in cutomer master+++
    [EventSubscriber(ObjectType::Table, Database::"Default Dimension", OnAfterValidateEvent, 'Dimension Value Code', false, false)]
    local procedure DimensionValue_OnAfterValidateEvent(var Rec: Record "Default Dimension")
    var
        L_CompanyLicenseHeader: Record "Company License Header";
    begin
        if UpperCase(Rec."Dimension Code") <> UpperCase('CUSTOMER TYPE') then
            exit;

        L_CompanyLicenseHeader.Reset();
        L_CompanyLicenseHeader.SetRange("Company Type", L_CompanyLicenseHeader."Company Type"::Customer);
        L_CompanyLicenseHeader.SetRange("Company No.", Rec."No.");
        if L_CompanyLicenseHeader.FindSet() then
            L_CompanyLicenseHeader.ModifyAll("Shortcut Dimension 3 Code", Rec."Dimension Value Code");
    end;

}