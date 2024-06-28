page 60556 "Company License Header Card"

{
    Caption = 'Company License Header Card';//25jan
    PageType = Document;
    //ApplicationArea = ;
    //UsageCategory = Administration;
    SourceTable = "Company License Header";
    //DelayedInsert = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Editable = PageEditBool;//discussion 23dec2020
                field("Company Type"; Rec."Company Type")//25jan
                {
                    ApplicationArea = all;//25jan
                                          // Caption = 'Company Type';//25jan

                    //19feb++
                    trigger OnValidate()
                    var
                    begin
                        if xRec."Company Type" <> xRec."Company Type"::" " then begin
                            if xRec."Company Type" <> Rec."Company Type" then begin
                                Error('Company Type Modifying not allowed');
                            end;
                        end;
                    end;
                    //19feb--
                }
                field("Company No."; Rec."Company No.")//25jan
                {
                    ApplicationArea = all;//25jan
                                          // Caption = 'Company No.';

                    //19feb++
                    trigger OnValidate()
                    var
                    begin
                        if xRec."Company No." <> '' then begin
                            if xRec."Company No." <> Rec."Company No." then begin
                                Error('Company No. Modifying not allowed');
                            end;
                        end;
                    end;
                    //19feb--
                }
                field("Company Name"; Rec."Company Name")//25jan
                {
                    ApplicationArea = all;//25jan
                                          // Caption = 'Company Name';//25jan
                }
                // field("Company Posting Group"; Rec."Company Posting Group")
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                // }
                field("License No."; Rec."License No.")//25jan
                {
                    ApplicationArea = all;//25jan
                                          //Caption = 'License No.';//25jan

                    // //19feb++
                    // trigger OnValidate()
                    // var
                    // begin
                    //     if xRec."License No." <> '' then begin
                    //         if xRec."License No." <> Rec."License No." then begin
                    //             Error('License No. Modifying not allowed');
                    //         end;
                    //     end;
                    // end;
                    // //19feb--

                }
                field("License Code"; Rec."License Code")//25jan
                {
                    ApplicationArea = all;//25jan
                                          //Caption = 'License Code';//25jan

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
                field("License Name"; Rec."License Name")//25jan
                {
                    ApplicationArea = all;//25jan
                    //Caption = 'License Name';//25jan
                }
                field("Grant Date"; Rec."Grant Date")//25jan
                {
                    ApplicationArea = all;//25jan
                    //Caption = 'Grant Date';//25jan
                }
                field("Expiry Date"; Rec."Expiry Date")//25jan
                {
                    ApplicationArea = all;//25jan
                    //Caption = 'Expiry Date';//25jan
                }
                field("Review Date"; Rec."Review Date")//25jan
                {
                    ApplicationArea = all;//25jan
                    //Caption = 'Review Date';//25jan
                }
                field("Ship-to-Code"; Rec."Ship-to-Code")//25jan
                {
                    ApplicationArea = all;//25jan
                    //Caption = 'Ship-to-Code';//25jan
                    Editable = Rec."Company Type" <> Rec."Company Type"::Customer;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = all;//25jan
                }
                field("Post code"; Rec."Post code")//25jan
                {
                    ApplicationArea = all;//25jan
                    //Caption = 'Post code';//25jan
                }
                field(Country; Rec.Country)
                {
                    ApplicationArea = all;//25jan
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = all;//25jan
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;//25jan
                }


            }
            part("Company License Line"; "Company License Line Subform")
            {
                ApplicationArea = all;
                Caption = 'Company License Line';//25jan
                Editable = PageEditBool;//23dec2020
                SubPageLink = "Company No." = FIELD("Company No."), "Company Type" = FIELD("Company Type"), "License Code" = FIELD("License Code"), "License No." = field("License No.");
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = true;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = true;
            }
        }

    }

    actions
    {
        area(Processing)
        {
            //discussion 23dec2020++
            action(Reopen)
            {
                ApplicationArea = All;
                Image = ReOpen;
                //Promoted = true;
                //PromotedIsBig = true;
                //PromotedCategory = Category5;
                trigger OnAction()
                begin
                    CLEAR(RecVETMedi);
                    RecVETMedi.Reset();
                    RecVETMedi.SetRange("Company Type", Rec."Company Type");
                    RecVETMedi.SetRange("Company No.", Rec."Company No.");
                    RecVETMedi.SetRange("License No.", Rec."License No.");
                    RecVETMedi.SetRange("License Code", Rec."License Code");
                    IF RecVETMedi.FindFirst() THEN BEGIN
                        //IF (RecVETMedi.Status<>RecVETMedi.Status::Open )THEN BEGIN
                        RecVETMedi.Status := RecVETMedi.Status::Open;
                        RecVETMedi.MODIFY;
                    END;
                end;
            }
            action(Release)
            {
                ApplicationArea = all;//25jan
                Image = ReleaseDoc;

                trigger OnAction()
                begin
                    //VALIDATE(Status,Status::Release);
                    /*Status:=Rec.Status::Release;
                    Rec.MODIFY;*/
                    if Rec."License No." = '' then//2feb 2020
                        Error('Please Select Licese No.');//2feb 2020
                    if Rec."License Code" = '' then//2feb 2020
                        Error('Please Select Licese Code.');//2feb 2020
                    Rec.Status := Rec.Status::Release;
                    Rec.MODIFY;
                    // RecVETMedi.Reset();
                    // RecVETMedi.SetRange("Company Type", Rec."Company Type");
                    // RecVETMedi.SetRange("Company No.", Rec."Company No.");
                    // RecVETMedi.SetRange("License No.", Rec."License No.");
                    // RecVETMedi.SetRange("License Code", Rec."License Code");
                    // IF RecVETMedi.FindFirst() THEN begin
                    //     RecVETMedi.Status := RecVETMedi.Status::Release;
                    //     RecVETMedi.MODIFY;
                    // END;
                    //CurrPage.Update(true);

                end;
            }
            //discussion 23dec2020--
        }
    }
    //discussion 23dec2020++
    trigger OnAfterGetRecord()
    var
    begin
        IF Rec.Status = Rec.Status::Open THEN
            PageEditBool := TRUE
        ELSE
            PageEditBool := FALSE;
    end;

    trigger OnInit()
    begin
        CLEAR(PageEditBool);

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        PageEditBool := TRUE;
        //NoEditable:=TRUE;
    end;
    //discussion 23dec2020--
    var
        myInt: Integer;
        PageEditBool: Boolean;//discussion 23dec2020
        RecVETMedi: Record "Company License Header";//discussion 23dec2020
}