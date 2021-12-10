pageextension 60508 "Customer Card Extend" extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {//25 feb ++
        addafter("&Jobs")
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

        }
        //25 feb --
    }

    var
        myInt: Integer;
}