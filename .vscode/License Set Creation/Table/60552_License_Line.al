table 60552 "License Line"
{

    DataClassification = ToBeClassified;

    fields
    {
        field(1; "License Code"; code[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2; "Line No."; Integer)
        {
            Editable = false;
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(3; "Item Category"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Item Category".Code;
            //24dec++
            /*
            trigger OnValidate()
            var
                recitemattmap: Record "Item Attribute Value Mapping";
            begin
                if Rec.ItemCategory <> '' then begin
                    Clear(allattributesid);
                    recitemattmap.Reset();
                    ;
                    recitemattmap.SetRange("No.", Rec.ItemCategory);
                    if recitemattmap.FindSet() then begin
                        repeat
                            allattributesid += format(recitemattmap."Item Attribute ID") + '|';
                        until recitemattmap.Next = 0;
                    end;
                    if allattributesid <> '' then begin
                        allattributesid := DelStr(allattributesid, (StrLen(allattributesid) - 1), 1)
                    end;

                end;
            end;*/
            //24dec--

        }
        field(4; "Item Attribute"; Text[250])
        {
            //Editable = false;
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
                            exit
                        end;



                    end;
                end;
            end;
            // DataClassification = ToBeClassified;
            //TableRelation = "Item Attribute" where("Item Category Code" = field(ItemCategory));
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
                            exit
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
        field(5; "Item Attribute Value"; Text[250])
        {
            DataClassification = ToBeClassified;
            // TableRelation = "Item Attribute Value".Value where("Attribute ID" = field("Item Attribute ID"));
            //2feb 2021++
            /*
            trigger OnValidate()
            var
                RecitemattVal: Record "Item Attribute Value";
            begin
                /*  RecitemattVal.Reset();
                  RecitemattVal.SetRange(Value, Rec."Item Attribute Value");
                  if RecitemattVal.FindFirst() then begin
                      Validate("Item Attribute Value ID", RecitemattVal.ID);
                  end;
            end;*/

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
        field(6; "Apply To"; Option)
        {
            OptionCaptionML = ENU = ' ,Sales,Purchase,Both';
            OptionMembers = " ",Sales,Purchase,Both;
            FieldClass = FlowField;
            CalcFormula = lookup("License Header"."Apply To" where("License Code" = field("License Code")));

        }
        field(7; "Customer Posting Group"; Code[20])
        {
            Editable = false;
            //DataClassification = ToBeClassified;
            TableRelation = "Customer Posting Group";
            FieldClass = FlowField;
            CalcFormula = lookup("License Header"."Customer Posting Group" where("License Code" = field("License Code")));

        }
        field(8; "Country"; Text[30])
        {
            Editable = false;
            //DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
            FieldClass = FlowField;
            CalcFormula = lookup("License Header".Country where("License Code" = field("License Code")));


        }
        field(9; "Mandatory"; Boolean)
        {
            //DataClassification = ToBeClassified;
            //FieldClass = FlowField;
            //CalcFormula = lookup("License Header".Mandatory where("License Code" = field(LicenseCode)));

        }
        //25jan++
        field(10; "Supplier Posting Group"; Code[20])
        {
            Editable = false;
            TableRelation = "Vendor Posting Group";
            FieldClass = FlowField;
            CalcFormula = lookup("License Header"."Supplier Posting Group" where("License Code" = field("License Code")));
        }
        field(11; Status; Option)
        {
            Editable = false;
            OptionCaptionML = ENU = 'Open,Release';
            OptionMembers = Open,Release;
            FieldClass = FlowField;
            CalcFormula = lookup("License Header".Status where("License Code" = field("License Code")));

        }
        field(12; "Country Validation"; Option)
        {
            Editable = false;
            OptionCaptionML = ENU = ' ,ALL';
            OptionMembers = " ",ALL;
            FieldClass = FlowField;
            CalcFormula = lookup("License Header"."Country Validation" where("License Code" = field("License Code")));
        }
        //25jan--
        //25feb++
        field(13; "Warning Type"; Option)
        {
            Editable = false;
            OptionCaptionML = ENU = ' ,Warning,Error';
            OptionMembers = " ",Warning,Error;
            FieldClass = FlowField;
            CalcFormula = lookup("License Header"."Warning Type" where("License Code" = field("License Code")));

        }
        field(14; "Warning Text"; Text[250])
        {
            Editable = false;
            //DataClassification = ToBeClassified;
            FieldClass = FlowField;
            CalcFormula = lookup("License Header"."Warning Text" where("License Code" = field("License Code")));

        }
        //25feb--
        field(15; "Apply to Child Categories"; Boolean)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("License Header"."Apply to Child Categories" where("License Code" = field("License Code")))
;
        }
    }

    keys
    {
        key(PK; "License Code", "Line No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DROUPDOWN; "License Code", "Line No.", "Item Attribute", "Item Attribute Value", "Item Category")
        {

        }
    }

    var
        myInt: Integer;
        allattributesid: Text[1024];//24dec

    trigger OnInsert()
    var
        recliceseheader: Record "License Header";
    begin
        recliceseheader.Reset();
        recliceseheader.SetRange("License Code", Rec."License Code");
        if recliceseheader.FindFirst then begin
            rec.Validate(Mandatory, recliceseheader.Mandatory);
        end;

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