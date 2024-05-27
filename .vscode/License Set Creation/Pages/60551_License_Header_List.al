page 60551 "License Header List"
{

    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "License Header";
    Editable = false;
    CardPageId = "License Header Card";
    Caption = 'License set';


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("License Code"; Rec."License Code")//25jan
                {
                    ApplicationArea = all;//25jan
                }
                field("License Name"; Rec."License Name")//25jan
                {
                    ApplicationArea = all;//25jan
                }

                field(Mandatory; Rec.Mandatory)
                {
                    ApplicationArea = all;//25jan
                }
                field("Apply To"; Rec."Apply To")
                {
                    ApplicationArea = all;//25jan
                }
                // field("Customer Posting Group"; Rec."Customer Posting Group")
                // {
                //     ApplicationArea = all;//25jan
                //                           // Caption = 'Customer Posting Group';//25jan
                // }
                // field("Supplier Posting Group"; Rec."Supplier Posting Group")//25jan
                // {
                //     ApplicationArea = all;//25jan
                // }
                field(Country; Rec.Country)
                {
                    ApplicationArea = all;//25jan
                }
                field("Country Validation"; Rec."Country Validation")
                {
                    ApplicationArea = all;
                }
                field("Warning Type"; Rec."Warning Type")
                {
                    ApplicationArea = all;//25jan
                }
                field("Warning Text"; Rec."Warning Text")
                {
                    ApplicationArea = all;//25jan
                }
                field(Status; Rec.Status)//25jan
                {
                    ApplicationArea = all;//25jan
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}