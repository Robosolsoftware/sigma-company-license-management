page 60503 "Company License Header List"
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
        }
    }
}