table 60502 "Company License Line"
{

    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Company Type"; Option)
        {
            OptionCaptionML = ENU = ' ,Customer,Supplier';
            OptionMembers = " ",Customer,Supplier;
            Editable = false;
        }
        field(2; "Company No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; "Line No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(4; "License No."; code[50])
        {
            Editable = false;
        }

        field(5; "License Code"; Code[100])
        {
            Editable = false;
        }
        field(6; "Item Category"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Category";
        }
        field(7; "Item Attribute"; Text[250])
        {
            Editable = true;
            //2feb 2021++
            trigger OnValidate()
            var
                RecItemAttserchig: Record "Item Attribute";
            begin
                if Rec."Item Attribute" <> '' then begin
                    RecItemAttserchig.Reset();
                    RecItemAttserchig.SetRange(Name, Rec."Item Attribute");
                    if RecItemAttserchig.FindFirst() then begin

                    end else begin
                        Error('Please select correct Item Atribute .');
                    end;
                end;
            end;
            //2feb 2021--
            //DataClassification = ToBeClassified;
            //TableRelation = "Item Attribute".Name; //where("Item Category Code" = field(ItemCategory));//ERROR
            //24dec++
            trigger OnLookup()
            var
                Recitematt: Record "Item Attribute";
                Recitematt2: Record "Item Attribute";
                pagelistattribute: page "Item Attributes";
                recitemattmap: Record "Item Attribute Value Mapping";
            begin
                if Rec."Item Category" <> '' then begin
                    Clear(allattributesid);
                    recitemattmap.Reset();

                    recitemattmap.SetRange("No.", Rec."Item Category");
                    if recitemattmap.FindSet() then begin
                        repeat
                            allattributesid += format(recitemattmap."Item Attribute ID") + '|';
                        until recitemattmap.Next = 0;
                    end;
                    // Message(allattributesid);
                    if allattributesid <> '' then begin
                        allattributesid := DelStr(allattributesid, StrLen(allattributesid), 1)
                    end;

                end;
                //Message(allattributesid);
                if allattributesid <> '' then begin


                    Recitematt.Reset();
                    Recitematt.SetFilter(ID, allattributesid);
                    if Recitematt.FindSet() then begin
                        //// Validate(ItemAttribute, Recitematt.Name);
                        Clear(pagelistattribute);
                        pagelistattribute.SetTableView(Recitematt);
                        pagelistattribute.LookupMode(true);
                        if pagelistattribute.RunModal = Action::LookupOK then begin
                            //Recitematt.Get(Recitematt.ID);
                            Recitematt2.Reset();
                            pagelistattribute.GetRecord(Recitematt2);
                            "Item Attribute ID" := Recitematt2.ID;
                            Validate("Item Attribute", Recitematt2.Name);
                            recitemattmap.Reset();
                            recitemattmap.SetRange("No.", Rec."Item Category");
                            recitemattmap.SetRange("Item Attribute ID", Rec."Item Attribute ID");
                            if recitemattmap.FindFirst() then begin
                                Validate("Item Attribute Value ID", recitemattmap."Item Attribute Value ID");
                            end;
                        end
                        else begin
                            exit;

                        end;

                    end;
                end;
            end;

        }
        field(20; "Item Attribute ID"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Attribute";/// where("Item Category Code" = field(ItemCategory));//24dec
            trigger OnValidate()
            var
                Recitematt: Record "Item Attribute";
            begin
                Recitematt.Reset();
                Recitematt.SetRange(ID, Rec."Item Attribute ID");
                if Recitematt.FindFirst() then begin
                    Validate("Item Attribute", Recitematt.Name);
                end;
            end;
            //24dec++
            trigger OnLookup()
            var
                Recitematt: Record "Item Attribute";
                Recitematt2: Record "Item Attribute";
                pagelistattribute: page "Item Attributes";
                recitemattmap: Record "Item Attribute Value Mapping";
            begin
                if Rec."Item Category" <> '' then begin
                    Clear(allattributesid);
                    recitemattmap.Reset();

                    recitemattmap.SetRange("No.", Rec."Item Category");
                    if recitemattmap.FindSet() then begin
                        repeat
                            allattributesid += format(recitemattmap."Item Attribute ID") + '|';
                        until recitemattmap.Next = 0;
                    end;
                    // Message(allattributesid);
                    if allattributesid <> '' then begin
                        allattributesid := DelStr(allattributesid, StrLen(allattributesid), 1)
                    end;

                end;
                //Message(allattributesid);
                if allattributesid <> '' then begin


                    Recitematt.Reset();
                    Recitematt.SetFilter(ID, allattributesid);
                    if Recitematt.FindSet() then begin
                        //// Validate(ItemAttribute, Recitematt.Name);
                        Clear(pagelistattribute);
                        pagelistattribute.SetTableView(Recitematt);
                        pagelistattribute.LookupMode(true);
                        if pagelistattribute.RunModal = Action::LookupOK then begin
                            //Recitematt.Get(Recitematt.ID);
                            Recitematt2.Reset();
                            pagelistattribute.GetRecord(Recitematt2);
                            Validate("Item Attribute ID", Recitematt2.ID);
                            recitemattmap.Reset();
                            recitemattmap.SetRange("No.", Rec."Item Category");
                            recitemattmap.SetRange("Item Attribute ID", Rec."Item Attribute ID");
                            if recitemattmap.FindFirst() then begin
                                Validate("Item Attribute Value ID", recitemattmap."Item Attribute Value ID");
                            end;
                        end
                        else begin
                            exit;

                        end;

                    end;
                end;
            end;
            //24dec--
        }
        field(21; "Item Attribute Value ID"; Integer)
        {

            //Editable = false;//24dec//25jan
            DataClassification = ToBeClassified;

            TableRelation = "Item Attribute Value".ID where("Attribute ID" = field("Item Attribute ID"));
            trigger OnValidate()
            var
                RecitemattVal: Record "Item Attribute Value";
            begin
                RecitemattVal.Reset();
                RecitemattVal.SetRange(ID, Rec."Item Attribute Value ID");
                if RecitemattVal.FindFirst() then begin
                    Validate("Item Attribute Value", RecitemattVal.Value);
                end;
            end;
        }
        field(8; "Item Attribute Value"; Text[250])
        {
            Editable = true;
            //2feb 2021++
            trigger OnValidate()
            var
                RecItemAttValueserchig: Record "Item Attribute Value";
            begin
                if Rec."Item Attribute Value" <> '' then begin
                    RecItemAttValueserchig.Reset();
                    RecItemAttValueserchig.SetRange(Value, Rec."Item Attribute Value");
                    if RecItemAttValueserchig.FindFirst() then begin

                    end else begin
                        Error('Please select correct Item Atribute Value.');
                    end;
                end;
            end;
            //2feb 2021--

            trigger OnLookup()
            var
                myInt: Integer;
                L_ItemAttValue: Record "Item Attribute Value";
            begin
                L_ItemAttValue.Reset();
                L_ItemAttValue.SetRange("Attribute ID", Rec."Item Attribute ID");
                if L_ItemAttValue.FindSet() then begin
                    if Page.RunModal(0, L_ItemAttValue) = Action::LookupOK then begin
                        "Item Attribute Value" := L_ItemAttValue.Value;
                        "Item Attribute Value ID" := L_ItemAttValue.ID;
                    end
                end;
            end;
            //DataClassification = ToBeClassified;
            //TableRelation = "Item Attribute Value" where("Attribute Name" = field(ItemAttribute));
        }
        field(9; "Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Customer Posting Group".Code;
            TableRelation = if ("Company Type" = const(Customer)) "Customer Posting Group".Code else
            if ("Company Type" = const(Supplier)) "Vendor Posting Group".Code;
        }
        field(10; "Shipping Country"; Text[30])
        {
            TableRelation = "Country/Region";

        }
        field(11; "Mandatory"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Grant Date"; Date)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Company License Header"."Grant Date" where("Company No." = field("Company No."), "Company Type" = field("Company Type"), "License No." = field("License No."), "License Code" = field("License Code")));
        }
        field(13; "Expiry Date"; Date)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Company License Header"."Expiry Date" where("Company No." = field("Company No."), "Company Type" = field("Company Type"), "License No." = field("License No."), "License Code" = field("License Code")));

        }
        field(14; "Post code"; Code[20])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Company License Header"."Post code" where("Company No." = field("Company No."), "Company Type" = field("Company Type"), "License No." = field("License No."), "License Code" = field("License Code")));

        }
        field(15; "Status"; Option)
        {
            Editable = false;
            OptionCaptionML = ENU = 'Open,Release';
            OptionMembers = Open,Release;
            FieldClass = FlowField;
            CalcFormula = lookup("Company License Header".Status where("Company No." = field("Company No."), "Company Type" = field("Company Type"), "License No." = field("License No."), "License Code" = field("License Code")));
        }

        //7jan2021++
        field(16; "Company Name"; Text[50])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Company License Header"."Company Name" where("Company No." = field("Company No."), "Company Type" = field("Company Type"), "License No." = field("License No."), "License Code" = field("License Code")));
        }
        //7jan2021--

    }

    keys
    {
        key(PK; "Company Type", "Company No.", "License No.", "License Code", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;
        allattributesid: Text[1024];//24dec

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}