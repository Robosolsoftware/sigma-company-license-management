pageextension 60509 "Customer List Extend" extends "Customer List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Return Orders")
        //25 feb ++
        {
            action("Company License")
            {
                ApplicationArea = all;
                Image = Job;
                Promoted = true;
                PromotedCategory = Category8;
                RunObject = Page "Company License Header List";
                RunPageLink = "Company No." = FIELD("No."), "Company Type" = filter(Customer);
                RunPageView = SORTING("Company Type", "Company No.", "License No.", "License Code");
            }
        }//25 feb --
    }

    var
        myInt: Integer;
}