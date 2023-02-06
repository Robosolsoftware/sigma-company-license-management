pageextension 60506 "Order Proc. Role Center Extend" extends "Order Processor Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter("Sales Orders")
        {
            group("Company License Management")
            {
                action("License Set Creation")
                {
                    ApplicationArea = Suite;
                    Caption = 'License Set Creation';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "License Header List";
                    ToolTip = 'Company License Management License Set Creation.';
                }
                action("Linking with Customer_Supplier")
                {
                    ApplicationArea = Suite;
                    Caption = 'Linking License Set';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Company License Header List";
                    ToolTip = 'Company License Management License Link with Customer or Supplier.';
                }
            }
        }
    }

    var
        myInt: Integer;
}

pageextension 60507 "Business manager Extend" extends "Business Manager Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter("Services & Extensions")
        {
            group("Company License Management")
            {
                action("License Set Creation")
                {
                    ApplicationArea = Suite;
                    Caption = 'License Set Creation';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "License Header List";
                    ToolTip = 'Company License Management License Set Creation.';
                }
                action("Linking with Customer_Supplier")
                {
                    ApplicationArea = Suite;
                    Caption = 'Linking License Set';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Company License Header List";
                    ToolTip = 'Company License Management License Link with Customer or Supplier.';
                }
            }

        }
    }

    var
        myInt: Integer;
}