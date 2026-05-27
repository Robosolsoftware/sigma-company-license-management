page 60554 "Company License Header List"
{
    Caption = 'Company License Header List';//25jan

    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "Company License Header";
    Editable = false;
    CardPageId = "Company License Header card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Company Type"; Rec."Company Type")//25jan
                {
                    ApplicationArea = all;//25jan
                    //Caption = 'Company Type';//25jan
                }
                field("Company No."; Rec."Company No.")//25jan
                {
                    ApplicationArea = all;//25jan
                                          // Caption = 'Company No.';
                }
                field("Company Name"; Rec."Company Name")//25jan
                {
                    ApplicationArea = all;//25jan
                    //Caption = 'Company Name';//25jan
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                    Editable = false;

                }
                field("License No."; Rec."License No.")//25jan
                {
                    ApplicationArea = all;//25jan
                    //Caption = 'License No.';//25jan
                }
                field("License Code"; Rec."License Code")//25jan
                {
                    ApplicationArea = all;//25jan
                                          // Caption = 'License Code';//25jan
                }
                field("License Name"; Rec."License Name")//25jan
                {
                    ApplicationArea = all;//25jan
                                          // Caption = 'License Name';//25jan
                }
                field("Grant Date"; Rec."Grant Date")//25jan
                {
                    ApplicationArea = all;//25jan
                                          // Caption = 'Grant Date';//25jan
                }
                field("Expiry Date"; Rec."Expiry Date")//25jan
                {
                    ApplicationArea = all;//25jan
                                          // Caption = 'Expiry Date';//25jan
                }
                field("Review Date"; Rec."Review Date")//25jan
                {
                    ApplicationArea = all;//25jan
                                          // Caption = 'Review Date';//25jan
                }
                field("Ship-to-Code"; Rec."Ship-to-Code")//25jan
                {
                    ApplicationArea = all;//25jan
                                          //  Caption = 'Ship-to-Code';//25jan
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = all;//25jan
                }
                field("Post code"; Rec."Post code")//25jan
                {
                    ApplicationArea = all;//25jan
                                          // Caption = 'Post code';//25jan
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
                field("Verification Date"; Rec."Verification Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("QAU Approved"; Rec."QAU Approved")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Blocked Reason"; Rec."Blocked Reason")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field(Synced; rec.Synced)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Verified By"; rec."Verified By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
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
            action(ActionName)
            {
                ApplicationArea = All;
                Visible = false;//25jan
                trigger OnAction();
                var
                    sale: Page "Sales Orders";
                begin

                end;
            }
            action("Update GPHC License No.")
            {
                ApplicationArea = All;
                trigger OnAction();
                var
                    companyLicHdr: Record "Company License Header";
                    reccomplicenseline1: Record "Company License Line";
                    reccomplicenseline: Record "Company License Line";
                    companyLicLine: Record "Company License Line";
                    IsBlank: Text[5];
                    OldLicenseNo: Code[20];
                    NewLicenseNo: Code[20];
                begin
                    companyLicHdr.Reset();
                    CurrPage.SetSelectionFilter(companyLicHdr);
                    companyLicHdr.SetRange("License Code", 'GPHC');
                    companyLicHdr.SetRange("Company Type", companyLicHdr."Company Type"::Customer);
                    if companyLicHdr.FindSet() then begin
                        repeat
                            Clear(OldLicenseNo);
                            OldLicenseNo := companyLicHdr."License No.";

                            IsBlank := CopyStr(companyLicHdr."License No.", 5, 5);
                            if IsBlank = '' then
                                NewLicenseNo := DelStr(companyLicHdr."License No.", 1, 5)
                            else
                                NewLicenseNo := DelStr(companyLicHdr."License No.", 1, 4);
                            companyLicHdr.Rename(companyLicHdr."Company Type", companyLicHdr."Company No.", companyLicHdr."Ship-to-Code", NewLicenseNo, 'GPHC');


                            //Update Line++
                            reccomplicenseline.Reset();
                            reccomplicenseline.SetRange("Company Type", companyLicHdr."Company Type");
                            reccomplicenseline.SetRange("Company No.", companyLicHdr."Company No.");
                            reccomplicenseline.SetRange("License Code", companyLicHdr."License Code");
                            reccomplicenseline.SetRange("License No.", OldLicenseNo);
                            if reccomplicenseline.FindSet() then begin
                                repeat
                                    reccomplicenseline1.Reset();
                                    reccomplicenseline1.SetRange("Company Type", reccomplicenseline."Company Type");
                                    reccomplicenseline1.SetRange("Company No.", reccomplicenseline."Company No.");
                                    reccomplicenseline1.SetRange("License Code", reccomplicenseline."License Code");
                                    reccomplicenseline1.SetRange("License No.", OldLicenseNo);
                                    reccomplicenseline1.SetRange("Line No.", reccomplicenseline."Line No.");
                                    if reccomplicenseline1.FindFirst() then begin
                                        reccomplicenseline1.Rename(reccomplicenseline1."Company Type", reccomplicenseline1."Company No.", NewLicenseNo, reccomplicenseline1."License Code", reccomplicenseline1."Line No.")
                                    end;
                                until reccomplicenseline.Next() = 0;
                            end;
                        until companyLicHdr.Next() = 0;
                    end;
                end;
            }
        }

    }
}