table 60554 "Company License Header"
{

    DataClassification = ToBeClassified;
    DrillDownPageId = "Company License Header List";
    LookupPageId = "Company License Header List";

    fields
    {
        field(1; "Company Type"; Option)
        {
            OptionCaptionML = ENU = ' ,Customer,Supplier';//25jan
            OptionMembers = " ",Customer,Supplier;//25jan

        }
        field(2; "Company No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = if ("Company Type" = const(Customer)) Customer."No." else
            if ("Company Type" = const(Supplier)) Vendor."No.";

            trigger OnValidate()
            var
                reccustomer: Record Customer;
                recvendor: Record Vendor;
            begin
                if Rec."Company Type" = Rec."Company Type"::Customer then begin


                    reccustomer.Reset();
                    reccustomer.SetRange("No.", "Company No.");
                    if reccustomer.FindFirst() then begin
                        Validate("Company Name", reccustomer.Name);
                        Validate("Post code", reccustomer."Post Code");
                        Validate("Company Posting Group", reccustomer."Customer Posting Group");
                        Validate(Address, reccustomer.Address);
                        Validate(Country, reccustomer."Country/Region Code");
                    end;
                end else begin
                    recvendor.Reset();
                    recvendor.SetRange("No.", Rec."Company No.");
                    if recvendor.FindFirst() then begin
                        Validate("Company Name", recvendor.Name);
                        Validate("Post code", recvendor."Post Code");
                        Validate("Company Posting Group", recvendor."Vendor Posting Group");
                        Validate(Address, recvendor.Address);
                        Validate(Country, recvendor."Country/Region Code");
                    end;
                end;
                if Rec."Company No." = '' then begin
                    Rec."Company Name" := '';
                    Rec."Post code" := '';
                    Rec."Company Posting Group" := '';
                    Rec.Address := '';
                    Rec.Country := '';
                end;
            end;

        }
        field(3; "Company Name"; Text[100])
        {
            Editable = false;
        }
        field(4; "License No."; code[50])
        {
            //2feb 2021 ++
            trigger OnValidate()
            var
                reccomplicenseline: Record "Company License Line";
            begin
                if Rec."License No." = '' then
                    Message('Alert!!License No. required');


                if xRec."License No." <> '' then begin
                    if xRec."License No." <> Rec."License No." then begin
                        reccomplicenseline.Reset();
                        reccomplicenseline.SetRange("Company Type", Rec."Company Type");
                        reccomplicenseline.SetRange("Company No.", Rec."Company No.");
                        reccomplicenseline.SetRange("License Code", Rec."License Code");
                        reccomplicenseline.SetRange("License No.", xRec."License No.");
                        if reccomplicenseline.FindSet() then begin
                            repeat
                                reccomplicenseline.Rename(reccomplicenseline."Company Type", reccomplicenseline."Company No.", Rec."License No.", reccomplicenseline."License Code", reccomplicenseline."Line No.")
                            until reccomplicenseline.Next() = 0;
                        end;
                    end;
                end;
            end;
            //2feb 2021 --

        }

        field(5; "License Code"; Code[100])
        {
            TableRelation = "License Header"."License Code" where(Status = const(Release));
            trigger OnValidate()
            var
                lineno: Integer;
                reclicenceheader: Record "License Header";
                reclicenseline: Record "License Line";
                reccomplicenseline: Record "Company License Line";
                reccomplicenselineinsert: Record "Company License Line";
            begin
                if Rec."Company Type" = "Company Type"::" " then
                    Error('Please select Company Type');
                if Rec."Company No." = '' then
                    Error('Please select Company No.');
                if Rec."License No." = '' then
                    Error('Please select License No.');
                if Rec."License Code" = '' then begin//2feb 2021
                    Validate("License Name", '');//2feb2021
                end;//2feb 2021
                if Rec."License Code" <> '' then begin
                    if Rec."License Code" <> xRec."License Code" then begin
                        reclicenceheader.Reset();
                        reclicenceheader.SetRange("License Code", Rec."License Code");
                        if reclicenceheader.FindFirst() then begin
                            Validate("License Name", reclicenceheader."License Name");
                        end;



                        reccomplicenselineinsert.Reset();
                        reccomplicenselineinsert.SetRange("Company Type", Rec."Company Type");
                        reccomplicenselineinsert.SetRange("Company No.", Rec."Company No.");
                        reccomplicenselineinsert.SetRange("License Code", Rec."License Code");
                        reccomplicenselineinsert.SetRange("License No.", Rec."License No.");
                        if reccomplicenselineinsert.FindLast then begin
                            lineno := reccomplicenselineinsert."Line No." + 10000;
                        end else begin
                            lineno := 10000;
                        end;

                        //2feb 2021 ++
                        reccomplicenselineinsert.Reset();
                        reccomplicenselineinsert.SetRange("Company Type", Rec."Company Type");
                        reccomplicenselineinsert.SetRange("Company No.", Rec."Company No.");
                        reccomplicenselineinsert.SetRange("License Code", Rec."License Code");
                        reccomplicenselineinsert.SetRange("License No.", Rec."License No.");
                        if reccomplicenselineinsert.FindSet() then begin
                            reccomplicenselineinsert.DeleteAll();
                            Commit();
                        end;
                        //2feb 2021 --

                        reclicenseline.Reset();
                        reclicenseline.SetRange("License Code", Rec."License Code");
                        if reclicenseline.FindSet then begin
                            repeat
                                //reccomplicenseline.Reset();
                                // reccomplicenseline.SetRange("License Code", reclicenseline."License Code");
                                // reccomplicenseline.SetRange("Item Category", reclicenseline."Item Category");
                                // reccomplicenseline.SetRange("Item Attribute ID", reclicenseline."Item Attribute ID");
                                // reccomplicenseline.SetRange("Item Attribute Value ID", reclicenseline."Item Attribute Value ID");
                                // IF not reccomplicenseline.FindFirst then begin
                                reccomplicenselineinsert.Reset();
                                reccomplicenselineinsert.Init();
                                reccomplicenselineinsert."Line No." := lineno;
                                reccomplicenselineinsert."Company No." := Rec."Company No.";
                                reccomplicenselineinsert."Company Type" := Rec."Company Type";
                                reccomplicenselineinsert."License Code" := Rec."License Code";
                                reccomplicenselineinsert."License No." := Rec."License No.";
                                reccomplicenselineinsert."Company Name" := Rec."Company Name";
                                reccomplicenselineinsert."Item Category" := reclicenseline."Item Category";
                                reccomplicenselineinsert."Item Attribute" := reclicenseline."Item Attribute";
                                reccomplicenselineinsert."Item Attribute ID" := reclicenseline."Item Attribute ID";
                                reccomplicenselineinsert."Item Attribute Value" := reclicenseline."Item Attribute Value";
                                reccomplicenselineinsert."Item Attribute Value ID" := reclicenseline."Item Attribute Value ID";
                                reclicenseline.CalcFields(Country, "Customer Posting Group", "Supplier Posting Group", "Apply To");
                                reccomplicenselineinsert."Shipping Country" := reclicenseline.Country;//2feb 2021
                                if reclicenseline."Apply To" = reclicenseline."Apply To"::Purchase then
                                    reccomplicenselineinsert."Posting Group" := reclicenseline."Supplier Posting Group"
                                else
                                    reccomplicenselineinsert."Posting Group" := reclicenseline."Customer Posting Group";//2feb 2021
                                reccomplicenselineinsert.Insert();
                                lineno += 10000;
                            //end else begin

                            // end;
                            until reclicenseline.Next = 0;
                        end;
                    end;
                end;
            end;
        }
        field(6; "License Name"; Text[250])
        {
            Editable = false;
        }
        field(7; "Grant Date"; Date)
        {
            // //discussion 23dec2020++
            // trigger OnValidate()
            // var
            // begin
            //     if Rec."Grant Date" > Today then
            //         Error('Invalid Date');
            // end;
            // //discussion 23dec2020--
        }
        field(8; "Expiry Date"; Date)
        {
            //discussion 23dec2020++
            trigger OnValidate()
            var
            begin
                if Rec."Grant Date" = 0D then
                    Error('Grant date invalid');

                if rec."Expiry Date" < Rec."Grant Date" then
                    Error('Invalid Date');
            end;
            //discussion 23dec2020--
        }
        field(9; "Review Date"; Date)
        {
            //discussion 23dec2020++
            trigger OnValidate()
            var
            begin
                if Rec."Grant Date" = 0D then
                    Error('Grant date invalid');

                if rec."Expiry Date" < Rec."Grant Date" then
                    Error('Invalid Date');
            end;
            //discussion 23dec2020--
        }
        field(10; "Ship-to-Code"; Code[10])
        {
            TableRelation = IF ("Company Type" = FILTER(Customer)) "Ship-to Address".Code WHERE("Customer No." = FIELD("Company No."))
            ELSE
            IF ("Company Type" = FILTER(Supplier)) "Order Address".Code WHERE("Vendor No." = FIELD("Company No."));
            //discussion 23dec2020++
            trigger OnValidate()
            var
                recshiptocode: Record "Ship-to Address";
                Recorderaddress: Record "Order Address";
            begin
                if Rec."Company Type" = Rec."Company Type"::Customer then begin
                    recshiptocode.Reset();
                    recshiptocode.SetRange(Code, Rec."Ship-to-Code");
                    if recshiptocode.FindFirst() then begin
                        Validate(Address, recshiptocode.Address);
                        Validate(Country, recshiptocode."Country/Region Code");
                        Validate("Post code", recshiptocode."Post Code");
                    end else begin
                        Validate(Address, '');
                        Validate(Country, '');
                        Validate("Post code", '');
                    end;

                    //vik++ added code as per Vaibhav
                end else begin
                    Recorderaddress.Reset();
                    Recorderaddress.SetRange(Code, Rec."Ship-to-Code");
                    if Recorderaddress.FindFirst() then begin
                        Validate(Address, Recorderaddress.Address);
                        Validate(Country, Recorderaddress."Country/Region Code");
                        Validate("Post code", Recorderaddress."Post Code");
                    end else begin
                        Validate(Address, '');
                        Validate(Country, '');
                        Validate("Post code", '');
                    end;
                    //vik--
                end;
            end;
            //discussion 23dec2020
        }
        field(11; "Address"; Text[250])
        {
            Editable = false;//discussion 23dec2020
        }
        field(12; "Post code"; Code[20])
        {
            Editable = false;//discussion 23dec2020
                             // TableRelation = IF (Country = CONST()) "Post Code" ELSE
                             // IF (Country = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD(Country));
        }
        field(13; "Country"; Text[30])
        {
            Editable = false;//discussion 23dec2020
            TableRelation = "Country/Region";
        }
        field(14; "Remarks"; Text[250])
        {

        }
        field(15; "Status"; Option)
        {
            Editable = false;
            OptionCaptionML = ENU = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(16; "Company Posting Group"; Code[20])
        {
            TableRelation = if ("Company Type" = const(Customer)) "Customer Posting Group".Code else
            if ("Company Type" = const(Supplier)) "Vendor Posting Group".Code;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Company Type", "Company No.", "Ship-to-Code", "License No.", "License Code")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;
        RecCompLicenseLine: Record "Company License Line";//19feb

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin
        //discussion 23dec2020++
        // if Rec.Status = Rec.Status::Release then
        //   Error('Status is release');
        //discussion 23dec2020--
    end;

    trigger OnDelete()
    begin
        Rec.TestField(Status, Status::Open);

        //19feb++
        RecCompLicenseLine.Reset();
        RecCompLicenseLine.SetRange("Company No.", Rec."Company No.");
        RecCompLicenseLine.SetRange("Company Type", Rec."Company Type");
        RecCompLicenseLine.SetRange("License Code", Rec."License Code");
        RecCompLicenseLine.SetRange("License No.", Rec."License No.");
        if RecCompLicenseLine.FindSet() then begin
            RecCompLicenseLine.DeleteAll();
        end;
        //19feb--
    end;

    trigger OnRename()
    begin

    end;

}