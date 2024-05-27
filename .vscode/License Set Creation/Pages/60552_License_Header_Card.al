page 60552 "License Header Card"

{

    PageType = Document;
    //ApplicationArea = All;
    //UsageCategory = Administration;
    SourceTable = "License Header";
    // DelayedInsert = true;
    AutoSplitKey = false;
    Caption = 'License set';
    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = PageEditBool;
                field("License Code"; Rec."License Code")//25jan2020
                {
                    ApplicationArea = All;//25jan2020

                    //19feb++
                    trigger OnValidate()
                    var
                    begin
                        if xRec."License Code" <> '' then begin
                            if xRec."License Code" <> Rec."License Code" then begin
                                Error('License Code Modifying not allowed');
                            end;
                        end;
                    end;
                    //19feb--

                }
                field("License Name"; Rec."License Name")//25jan2020
                {
                    ApplicationArea = all;//25jan2020

                }

                field(Mandatory; Rec.Mandatory)
                {
                    ApplicationArea = all;//25jan2020
                }
                field("Apply To"; Rec."Apply To")
                {
                    ApplicationArea = all;//25jan2020
                }
                // field("Customer Posting Group"; Rec."Customer Posting Group")//25jan2020
                // {
                //     ApplicationArea = all;//25jan2020
                //     //Caption = 'Customer Posting Group';//25jan2020
                // }
                // //25jan++
                // field("Supplier Posting Group"; Rec."Supplier Posting Group")
                // {
                //     ApplicationArea = all;
                // }
                //25jan--
                //27jan++
                field("Country Validation"; Rec."Country Validation")
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    var
                    begin
                        if Rec."Country Validation" = Rec."Country Validation"::ALL then begin
                            Rec.Validate(Country, '');
                            COuntryEditable := false;
                        end else begin
                            COuntryEditable := true;
                        end;
                    end;

                }
                //27jan--
                field(Country; Rec.Country)
                {
                    ApplicationArea = all;//25jan2020
                    Editable = COuntryEditable;//27jan
                }
                field("Warning Type"; Rec."Warning Type")
                {
                    ApplicationArea = all;//25jan2020
                }
                field("Warning Text"; Rec."Warning Text")
                {
                    ApplicationArea = all;//25jan
                }
                field(Status; Rec.Status)//25jan
                {
                    ApplicationArea = all;//25jan
                    Editable = false;
                }
                field("Apply to Child Categories"; Rec."Apply to Child Categories")
                {
                    ApplicationArea = All;
                }


            }
            part("License conditions"; "License Line Subform")//25jan
            {
                ApplicationArea = all;
                SubPageLink = "License Code" = field("License Code");
                Editable = PageEditBool;
                Caption = 'License conditions';
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                Visible = false;//25jan2020
                trigger OnAction()
                begin

                end;
            }
            action(Reopen)
            {
                Image = ReOpen;
                ApplicationArea = all;
                trigger OnAction()
                begin
                    CLEAR(RecVETMedi);
                    IF RecVETMedi.GET(Rec."License Code") THEN BEGIN
                        RecVETMedi.Status := RecVETMedi.Status::Open;
                        RecVETMedi.MODIFY;
                    END;
                end;
            }

            action(Release)
            {
                Image = ReleaseDoc;
                ApplicationArea = all;

                trigger OnAction()
                begin
                    CLEAR(RecVETMedi);
                    if Rec."Country Validation" = Rec."Country Validation"::" " then begin
                        if Rec.Country = '' then
                            Error('Please select Country');
                    end;

                    if Rec."Warning Type" = Rec."Warning Type"::" " then
                        Error('Please select Warning Type');

                    if Rec."Warning Text" = '' then begin
                        Error('Please select Warning Text');
                    end;

                    IF RecVETMedi.GET(Rec."License Code") THEN BEGIN
                        RecVETMedi.Status := RecVETMedi.Status::Release;
                        RecVETMedi.MODIFY;
                    END;

                end;
            }
        }
    }
    trigger OnInit()
    begin
        Clear(COuntryEditable);
        CLEAR(PageEditBool);
    end;

    trigger OnAfterGetRecord()
    var
    begin
        IF Rec.Status = Rec.Status::Open THEN
            PageEditBool := TRUE
        ELSE
            PageEditBool := FALSE;
        IF Rec."Country Validation" = Rec."Country Validation"::ALL THEN
            COuntryEditable := FALSE
        ELSE
            COuntryEditable := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        PageEditBool := TRUE;
        COuntryEditable := true;//27jan
    end;

    var
        myInt: Integer;
        COuntryEditable: Boolean;
        RecVETMedi: Record "License Header";//27jan
        PageEditBool: Boolean;

}