pageextension 60559 "Customer List Extend" extends "Customer List"
{
    layout
    {
        // Add changes to page layout here
        //Rehan(Company_Lic_expired_cust)
        // modify("No.")
        // {
        //     StyleExpr = Color;
        // }
        // modify(Name)
        // {
        //     StyleExpr = Color;
        // }
        // modify("Phone No.")
        // {
        //     StyleExpr = Color;
        // }
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

        Color: Text[250];

        GetDate: Date;

    trigger OnAfterGetRecord()
    //Rehan(Company_Lic_expired_cust)
    var
        CompanyLic: Record "Company License Header";
    // salesreceivable: Record "Sales & Receivables Setup";
    begin

        //salesreceivable.Reset;
        Clear(Color);
        // Clear(GetDate);
        // salesreceivable.Get;
        // GetDate := CalcDate(salesreceivable."Highlight Expire License", Today());
        CompanyLic.reset;
        CompanyLic.SetRange("Company Type", CompanyLic."Company Type"::Customer);
        CompanyLic.SetRange("Company No.", Rec."No.");
        CompanyLic.SetFilter("Expiry Date", '<=%1', Today);
        if CompanyLic.FindFirst() then
            Color := 'Attention'
        else
            Color := 'FALSE';

    end;
}