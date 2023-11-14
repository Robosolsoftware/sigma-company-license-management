page 60555 "Company License Line Subform"
{

    Caption = 'Company License Line Subform';//25jan
    PageType = ListPart;
    //ApplicationArea = All;
    //UsageCategory = Administration;
    SourceTable = "Company License Line";
    //DelayedInsert = true;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(group)
            //group(GroupName)
            {
                field("Company Type"; Rec."Company Type")//25jan
                {
                    ApplicationArea = all;//25jan
                                          // Caption = 'Company Type';
                    Visible = false;//25feb
                }
                field("Company No."; Rec."Company No.")//25jan
                {
                    ApplicationArea = all;//25jan
                    //Caption = 'Company No.';
                    Visible = false;//25feb
                }
                //7jan2021++
                field("Company Name"; Rec."Company Name")//25jan
                {
                    ApplicationArea = all;//25jan
                    //Caption = 'Company Name';
                    Visible = false;//25feb
                }
                //7jan2021--
                field("License Code"; Rec."License Code")//25jan
                {
                    ApplicationArea = all;//25jan
                                          //   Caption = 'License Code';
                    Visible = false;//25feb
                }
                field("License No."; Rec."License No.")//25jan
                {
                    ApplicationArea = all;//25jan
                    //Caption = 'License No.';
                    Visible = false;//25feb
                }
                field("Line No."; Rec."Line No.")//25jan
                {
                    ApplicationArea = all;//25jan
                                          // Caption = 'Line No.';
                    Visible = false;//25feb
                }
                field("Item Category"; Rec."Item Category")//25jan
                {
                    ApplicationArea = all;//25jan
                                          // Caption = 'Item Category';
                }
                field("Item Attribute ID"; Rec."Item Attribute ID")//25jan
                {
                    ApplicationArea = all;//25jan
                                          // Caption = 'Item Attribute ID';
                    Visible = false;
                }
                field("Item Attribute"; Rec."Item Attribute")//25jan
                {
                    ApplicationArea = all;//25jan
                                          // Caption = 'Item Attribute';
                }
                field("Item Attribute Value ID"; Rec."Item Attribute Value ID")//25jan
                {
                    ApplicationArea = all;//25jan
                    //Caption = 'Item Attribute Value ID';
                    Visible = false;
                }
                field("Item Attribute Value"; Rec."Item Attribute Value")//25jan
                {
                    ApplicationArea = all;//25jan
                    //Caption = 'Item Attribute Value';
                }
                field("Posting Group"; Rec."Posting Group")//25jan
                {
                    ApplicationArea = all;//25jan
                                          //  Caption = 'Customer Posting Group';
                }
                field("Shipping Country"; Rec."Shipping Country")//25jan
                {
                    ApplicationArea = all;//25jan
                    //Caption = 'Shipping Country';
                }
                field(Mandatory; Rec.Mandatory)
                {
                    ApplicationArea = all;
                    Visible = false;//25feb
                }
                field("Grant Date"; Rec."Grant Date")//25jan
                {
                    ApplicationArea = all;//25jan
                    //Caption = 'Grant Date';
                    Visible = false;//25feb
                }
                field("Expiry Date"; Rec."Expiry Date")//25jan
                {
                    ApplicationArea = all;//25jan
                                          // Caption = 'Expiry Date';
                    Visible = false;//25feb
                }
                field("Post code"; Rec."Post code")//25jan
                {
                    ApplicationArea = all;//25jan
                                          // Caption = 'Post code';
                    Visible = false;//25feb
                }
                //7jan2021++
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Visible = false;//25feb
                }
                //7jan2021--

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
                //Visible = false;
                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}