table 60500 "License Header"
{

    DataClassification = ToBeClassified;
    DrillDownPageId = "License Header List";
    LookupPageId = "License Header List";

    fields
    {
        field(1; "License Code"; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "License Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Mandatory; Boolean)
        {
            //DataClassification = ToBeClassified;
        }
        field(4; "Apply To"; Option)
        {
            OptionCaptionML = ENU = ' ,Sales,Purchase,Both';
            OptionMembers = " ",Sales,Purchase,Both;

        }
        field(5; "Customer Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Customer Posting Group".Code;
        }
        field(6; "Country"; Text[30])
        {

            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";


        }
        field(7; "Warning Type"; Option)
        {
            OptionCaptionML = ENU = ' ,Warning,Error';
            OptionMembers = " ",Warning,Error;
        }
        field(8; "Warning Text"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        //25jan++
        field(9; "Supplier Posting Group"; Code[20])
        {
            TableRelation = "Vendor Posting Group";
        }
        field(10; Status; Option)
        {
            //Editable = false;
            OptionCaptionML = ENU = 'Open,Release';
            OptionMembers = Open,Release;

        }
        //25jan--
        //27jan++
        field(11; "Country Validation"; Option)
        {
            OptionCaptionML = ENU = ' ,ALL';
            OptionMembers = " ",ALL;

        }
        //27jan--

        field(12; "Apply to Child Categories"; Boolean)
        {

        }

    }

    keys
    {
        key(PK; "License Code")
        {
            Clustered = true;
        }
        key(CompLice; "License Name", Mandatory, "Apply To", Country, "Customer Posting Group")
        {
            Enabled = true;
        }
    }

    fieldgroups
    {
        fieldgroup(Dropdown; "License Code", "License Name", Mandatory, "Apply To", Country, "Customer Posting Group")
        {

        }
    }

    var
        myInt: Integer;
        RecLicenseLine: Record "License Line";


    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
        //19feb++
        RecLicenseLine.Reset();
        RecLicenseLine.SetRange("License Code", Rec."License Code");
        if RecLicenseLine.FindSet() then begin
            RecLicenseLine.DeleteAll();
        end;
        //19feb--
    end;

    trigger OnRename()
    begin

    end;

}