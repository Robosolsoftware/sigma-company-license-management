page 60502 "License Line Subform"
{

    PageType = ListPart;
    //ApplicationArea = All;
    //UsageCategory = Administration;
    SourceTable = "License Line";
    DeleteAllowed = true;
    AutoSplitKey = true;
    Caption = 'License conditions';
    layout
    {
        area(Content)
        {
            repeater(group)
            //group(GroupName)
            {
                field("License Code"; Rec."License Code")////25jan
                {
                    ApplicationArea = all;//25jan
                                          // Caption = 'License Code';//25jan
                    Visible = false;//25feb
                }
                field("Line No."; Rec."Line No.")//25jan
                {
                    ApplicationArea = all;//25jan
                                          // caption = 'Line No.';//25jan
                    Visible = false;//25feb
                }
                field("Item Category"; Rec."Item Category")//25jan
                {
                    ApplicationArea = all;//25jan
                                          // Caption = 'Item Category';//25jan
                }
                field("Item Attribute ID"; Rec."Item Attribute ID")//25jan
                {
                    ApplicationArea = all;//25jan
                                          // Caption = 'Item Attribute ID';//25jan
                    Visible = false;
                }
                field("Item Attribute"; Rec."Item Attribute")//25jan
                {
                    ApplicationArea = all;//25jan
                                          // Caption = 'Item Attribute';//25jan
                }
                field("Item Attribute Value ID"; Rec."Item Attribute Value ID")//25jan
                {
                    ApplicationArea = all;//25jan
                                          // Caption = 'Item Attribute Value ID';//25jan
                    Visible = false;
                }
                field("Item Attribute Value"; Rec."Item Attribute Value")//25jan
                {
                    ApplicationArea = all;//25jan
                                          //  Caption = 'Item Attribute Value';//25jan
                }
                field("Apply To"; Rec."Apply To")
                {
                    ApplicationArea = all;//25jan
                    Visible = false;//25feb
                }
                field("Customer Posting Group"; Rec."Customer Posting Group")//25jan
                {
                    ApplicationArea = all;//25jan
                                          // Caption = 'Customer Posting Group';//25jan
                    Visible = false;//25feb
                }
                field("Supplier Posting Group"; Rec."Supplier Posting Group")//25jan
                {
                    ApplicationArea = all;//25jan
                    Visible = false;//25feb
                }
                field(Country; Rec.Country)
                {
                    ApplicationArea = all;//25jan
                    Visible = false;//25feb
                }
                field("Country Validation"; Rec."Country Validation")
                {
                    ApplicationArea = all;
                    Visible = false;//25feb
                }
                field(Mandatory; Rec.Mandatory)
                {
                    ApplicationArea = all;//25jan
                    Visible = false;//25feb
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Visible = false;//25feb
                }
                field("Warning Type"; Rec."Warning Type")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Warning Text"; Rec."Warning Text")
                {
                    ApplicationArea = all;
                    Visible = false;
                }

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
                //Visible = false;//25jan
                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}