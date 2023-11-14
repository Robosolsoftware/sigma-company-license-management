pageextension 60561 "Vendor List Extend" extends "Vendor List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Return Orders")
        {
            //25 feb ++
            action("Company License")
            {
                ApplicationArea = all;
                Image = Job;
                Promoted = true;
                PromotedCategory = Category6;
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