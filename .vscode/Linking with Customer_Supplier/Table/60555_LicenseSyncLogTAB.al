table 60555 "License Sync Log"
{
    Caption = 'License Sync Log';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "License No."; Code[20])
        {
            Caption = 'License No.';
        }
        field(3; "Sync DateTime"; DateTime)
        {
            Caption = 'Sync Date/Time';
        }
        field(4; "Synced By"; Code[50])
        {
            Caption = 'Synced By';
        }
        field(5; "Field Name"; Text[100])
        {
            Caption = 'Field Name';
        }
        field(6; "Old Value"; Text[250])
        {
            Caption = 'Old Value';
        }
        field(7; "New Value"; Text[250])
        {
            Caption = 'New Value';
        }
        field(8; "Sync Status"; Option)
        {
            Caption = 'Sync Status';
            OptionMembers = Success,Failed,"Token Refreshed";
            OptionCaption = 'Success,Failed,Token Refreshed';
        }
        field(9; "HTTP Status"; Integer)
        {
            Caption = 'HTTP Status';
        }
        field(10; "Error Message"; Text[500])
        {
            Caption = 'Error Message';
        }
        field(11; "Batch ID"; Guid)
        {
            Caption = 'Batch ID';
            // Groups all field changes from a single sync run
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(K2; "License No.", "Sync DateTime")
        {
        }
        key(K3; "Batch ID")
        {
        }
    }
}
