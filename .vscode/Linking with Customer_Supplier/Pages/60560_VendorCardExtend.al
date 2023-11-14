pageextension 60560 "Vendor Card Extend" extends "Vendor Card"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter(Purchases)
        {
            //25 feb ++
            action("Company License")
            {
                ApplicationArea = all;
                Image = Job;
                Promoted = true;
                PromotedCategory = Category7;
                RunObject = Page "Company License Header List";
                RunPageLink = "Company No." = FIELD("No."), "Company Type" = filter(Supplier);
                RunPageView = SORTING("Company Type", "Company No.", "License No.", "License Code");
            }
            //25 feb --
        }

    }

    var
        myInt: Integer;
}