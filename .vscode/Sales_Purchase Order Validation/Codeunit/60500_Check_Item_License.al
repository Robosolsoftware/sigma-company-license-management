/*

++++++++++++++++++++++++Structured code for license check+++++++++++++++++++++++ CS++++++
Function List
1. CheckingLicenseSales: Event subscriber for Sales Line on No validate
2. CheckingLicensePurh: Event subscriber for Purchase Line on No validate
3. ValidateLicense: Common function to check Item Attribute and License Line for Sales and Purchase
4. ValidateCompanyLicense: Common function to check customer license line

Create below functions
1. Common function to check Item Attribute and License Line for Sales and Purchase
Function: ValidateLicense
Date:28/01/21
CalledFrom: Event subscribers (CheckingLicenseSales,CheckingLicensePurh)

2. Common function to check customer license line
Function: ValidateCompanyLicense
Date:28/01/21
CalledFrom: Event subscribers (ValidateLicense)

++++++++++++++++++++++++Structured code for license check+++++++++++++++++++++++ CS+++++++
*/

codeunit 60551 "Check Item License"
{


    EventSubscriberInstance = StaticAutomatic;
    [EventSubscriber(ObjectType::Table, 37, 'OnBeforeValidateEvent', 'No.', true, true)]
    local procedure CheckingLicenseSales(var Rec: Record "Sales Line")
    var
        RecSalesHeader: Record "Sales Header";
        RecItem: Record Item;
    begin
        if Rec.Type = Rec.Type::Item then begin
            //to get post code and custpostgrp
            RecSalesHeader.Reset();
            RecSalesHeader.SetRange("No.", Rec."Document No.");
            RecSalesHeader.SetFilter("Document Type", '%1|%2', RecSalesHeader."Document Type"::Order, RecSalesHeader."Document Type"::Quote);
            if RecSalesHeader.FindFirst() then
                ValidateLicense(0, RecSalesHeader."Sell-to Customer No.", RecSalesHeader."Customer Posting Group", RecSalesHeader."Ship-to Country/Region Code", RecSalesHeader."Order Date", Rec."No.", RecSalesHeader."Ship-to Post Code")
            // else
            //     Error('Sales Header not found for Line %1', Rec.RecordId);
        end;
    end;

    [EventSubscriber(ObjectType::Table, 39, 'OnBeforeValidateEvent', 'No.', true, true)]
    local procedure CheckingLicensePurh(var Rec: Record "Purchase Line")
    var
        RecLicenceHeader: Record "License Header";
        RecPurchHeader: Record "Purchase Header";
        RecItem: Record Item;
    begin
        if Rec.Type = Rec.Type::Item then begin
            //to get post code and custpostgrp
            RecPurchHeader.Reset();
            RecPurchHeader.SetRange("No.", Rec."Document No.");
            RecPurchHeader.SetFilter("Document Type", '%1|%2', RecPurchHeader."Document Type"::Order, RecPurchHeader."Document Type"::Quote);
            if RecPurchHeader.FindFirst() then
                ValidateLicense(1, RecPurchHeader."Buy-from Vendor No.", RecPurchHeader."Vendor Posting Group", RecPurchHeader."Buy-from Country/Region Code", RecPurchHeader."Order Date", Rec."No.", RecPurchHeader."Buy-from Post Code")
            // else
            //     Error('Purchase Header not found for Line %1', Rec.RecordId);
        end;
    end;

    procedure ValidateLicense(CalledFrom: Option "Sales","Purchase"; CompanyNo: code[20]; PostingGroup: Code[20]; shippingCountry: Text[30]; OrderDate: Date; ItemNo: Code[20]; PostCode: code[20])
    var
        ConfirmManagement: Codeunit "Confirm Management";
        RecLicenceHeader: Record "License Header";
        Reccomplicensheader: Record "Company License Header";
        RecLicenseLine: Record "License Line";
        ReccomplicensLine: Record "Company License Line";
        RecItemAttValMap: Record "Item Attribute Value Mapping";
        RecItem: Record Item;
        FinalPostingCode: Code[20];
        FindCategory: Code[20];
        CheckValidation: Boolean;
        AttributeValue: Text[500];
        ItemAttributeValue: Record "Item Attribute Value";
        ItemAttribute: Record "Item Attribute";
    begin
        RecItem.Reset();
        RecItem.SetRange("No.", ItemNo);
        if RecItem.FindFirst() then;

        // To get attibute details
        RecItemAttValMap.Reset();
        RecItemAttValMap.SetRange("Table ID", 27);
        RecItemAttValMap.SetRange("No.", ItemNo);
        if RecItemAttValMap.FindSet() then begin
            repeat
                //New Code Added 09/26/2021+++
                Clear(AttributeValue);
                ItemAttribute.Reset();
                ItemAttribute.SetRange(ID, RecItemAttValMap."Item Attribute ID");
                if ItemAttribute.FindFirst() then begin
                    ItemAttributeValue.SetRange("Attribute ID", ItemAttribute.ID);
                    ItemAttributeValue.SetRange(ID, RecItemAttValMap."Item Attribute Value ID");
                    if ItemAttributeValue.FindFirst() then begin
                        AttributeValue := ItemAttributeValue.Value;
                    end;
                end;


                Clear(CompanyLicenseFound);
                Clear(licenseCopulsary);
                RecLicenseLine.CalcFields(Status);
                //RecLicenseLine.SetCurrentKey("Warning Type");
                RecLicenseLine.Reset();
                //RecLicenseLine.SetRange("Item Category", RecItem."Item Category Code"); //Commented By Abdul++
                RecLicenseLine.SetRange("Item Attribute ID", RecItemAttValMap."Item Attribute ID");
                RecLicenseLine.SetRange("Item Attribute Value ID", RecItemAttValMap."Item Attribute Value ID");
                RecLicenseLine.SetRange(Status, RecLicenseLine.Status::Release);
                RecLicenseLine.SetRange(Mandatory, true);
                //RecLicenseLine.SetAscending("Warning Type", false);
                if RecLicenseLine.FindSet() then begin
                    repeat
                        Clear(FindCategory);
                        CheckValidation := false;
                        RecLicenseLine.CalcFields("Apply to Child Categories");
                        if RecLicenseLine."Apply to Child Categories" = true then begin
                            if RecLicenseLine."Item Category" = RecItem."Item Category Code" then begin
                                FindCategory := RecLicenseLine."Item Category";
                                CheckValidation := true;
                            end else begin
                                if RecLicenseLine."Item Category" = FindParentCategory(RecItem."Item Category Code") then begin
                                    FindCategory := RecLicenseLine."Item Category";
                                    CheckValidation := true;
                                end;
                            end;
                        end else begin
                            if RecLicenseLine."Item Category" = RecItem."Item Category Code" then begin
                                FindCategory := RecLicenseLine."Item Category";
                                CheckValidation := true;
                            end;
                        end;

                        if CheckValidation = true then begin
                            RecLicenseLine.CalcFields("Warning Text", "Warning Type", "Apply To", "Supplier Posting Group", "Customer Posting Group", Country, "Country Validation");
                            /*
                                                //posting group if sale order
                                                Clear(FinalPostingCode);
                                                if CalledFrom = 0 then begin
                                                    FinalPostingCode := RecLicenseLine."Customer Posting Group"
                                                end else begin
                                                    //posting group if Purchase order
                                                    FinalPostingCode := RecLicenseLine."Supplier Posting Group";
                                                end;
                            */
                            if CalledFrom = CalledFrom::Purchase then begin
                                If RecLicenseLine."Country Validation" = RecLicenseLine."Country Validation"::" " then begin
                                    if (RecLicenseLine."Customer Posting Group" = PostingGroup) and (RecLicenseLine.Country = shippingCountry) then begin
                                        if (RecLicenseLine."Apply To" = RecLicenseLine."Apply To"::Both) or (RecLicenseLine."Apply To" = RecLicenseLine."Apply To"::Purchase) then begin
                                            licenseCopulsary := true;
                                            //ValidateCompanyLicense(CalledFrom, CompanyNo, RecItem."Item Category Code", RecItemAttValMap."Item Attribute ID", RecItemAttValMap."Item Attribute Value ID", RecLicenseLine."License Code", PostingGroup, shippingCountry, OrderDate, true, PostCode);
                                            ValidateCompanyLicense(CalledFrom, CompanyNo, FindCategory, RecItemAttValMap."Item Attribute ID", RecItemAttValMap."Item Attribute Value ID", RecLicenseLine."License Code", PostingGroup, shippingCountry, OrderDate, true, PostCode, ItemNo, AttributeValue);
                                        end;
                                    end;
                                end Else Begin
                                    if (RecLicenseLine."Customer Posting Group" = PostingGroup) then begin
                                        if (RecLicenseLine."Apply To" = RecLicenseLine."Apply To"::Both) or (RecLicenseLine."Apply To" = RecLicenseLine."Apply To"::Purchase) then begin
                                            licenseCopulsary := true;
                                            //ValidateCompanyLicense(CalledFrom, CompanyNo, RecItem."Item Category Code", RecItemAttValMap."Item Attribute ID", RecItemAttValMap."Item Attribute Value ID", RecLicenseLine."License Code", PostingGroup, shippingCountry, OrderDate, false, PostCode);
                                            ValidateCompanyLicense(CalledFrom, CompanyNo, FindCategory, RecItemAttValMap."Item Attribute ID", RecItemAttValMap."Item Attribute Value ID", RecLicenseLine."License Code", PostingGroup, shippingCountry, OrderDate, false, PostCode, ItemNo, AttributeValue);
                                        end;
                                    end;
                                End;
                            end else begin
                                If RecLicenseLine."Country Validation" = RecLicenseLine."Country Validation"::" " then begin
                                    if (RecLicenseLine."Customer Posting Group" = PostingGroup) and (RecLicenseLine.Country = shippingCountry) then begin
                                        if (RecLicenseLine."Apply To" = RecLicenseLine."Apply To"::Both) or (RecLicenseLine."Apply To" = RecLicenseLine."Apply To"::Sales) then begin
                                            licenseCopulsary := true;
                                            //ValidateCompanyLicense(CalledFrom, CompanyNo, RecItem."Item Category Code", RecItemAttValMap."Item Attribute ID", RecItemAttValMap."Item Attribute Value ID", RecLicenseLine."License Code", PostingGroup, shippingCountry, OrderDate, true, PostCode);
                                            ValidateCompanyLicense(CalledFrom, CompanyNo, FindCategory, RecItemAttValMap."Item Attribute ID", RecItemAttValMap."Item Attribute Value ID", RecLicenseLine."License Code", PostingGroup, shippingCountry, OrderDate, true, PostCode, ItemNo, AttributeValue);
                                        end;
                                    end;
                                end Else Begin
                                    if (RecLicenseLine."Customer Posting Group" = PostingGroup) then begin
                                        if (RecLicenseLine."Apply To" = RecLicenseLine."Apply To"::Both) or (RecLicenseLine."Apply To" = RecLicenseLine."Apply To"::Sales) then begin
                                            licenseCopulsary := true;
                                            //ValidateCompanyLicense(CalledFrom, CompanyNo, RecItem."Item Category Code", RecItemAttValMap."Item Attribute ID", RecItemAttValMap."Item Attribute Value ID", RecLicenseLine."License Code", PostingGroup, shippingCountry, OrderDate, false, PostCode);
                                            ValidateCompanyLicense(CalledFrom, CompanyNo, FindCategory, RecItemAttValMap."Item Attribute ID", RecItemAttValMap."Item Attribute Value ID", RecLicenseLine."License Code", PostingGroup, shippingCountry, OrderDate, false, PostCode, ItemNo, AttributeValue);
                                        end;
                                    end;
                                End;
                            end;
                        end;
                    until RecLicenseLine.Next = 0;
                    //Bug+++
                    //Commented by Abdul+++
                    /*if licenseCopulsary = true then begin
                        if CompanyLicenseFound = false then begin
                            //25feb++
                            if RecLicenseLine."Warning Type" = RecLicenseLine."Warning Type"::Error then begin
                                Error(RecLicenseLine."Warning Text");
                            end;
                            if RecLicenseLine."Warning Type" = RecLicenseLine."Warning Type"::Warning then begin
                                if not ConfirmManagement.GetResponseOrDefault(StrSubstNo(RecLicenseLine."Warning Text"), true) then begin

                                    Error('Process Stopped Please Revert Changes');
                                end else begin

                                end;
                            end;
                            //25feb--
                            if RecLicenseLine."Warning Type" = RecLicenseLine."Warning Type"::" " then//25feb
                                Error('License setup manadatory found and valid customer licence not found');
                        end;
                    end;*/
                    //Commented by Abdul+++
                    //bug--
                end;
            until RecItemAttValMap.Next = 0;
        end;
    end;


    procedure ForIntegration_ValidateLicense(CalledFrom: Option "Sales","Purchase"; CompanyNo: code[20]; PostingGroup: Code[20]; shippingCountry: Text[30]; OrderDate: Date; ItemNo: Code[20]; PostCode: code[20]; var _CompanyLicenseError: Text[100]; var _Attribute: Code[20])
    var
        ConfirmManagement: Codeunit "Confirm Management";
        RecLicenceHeader: Record "License Header";
        Reccomplicensheader: Record "Company License Header";
        RecLicenseLine: Record "License Line";
        ReccomplicensLine: Record "Company License Line";
        RecItemAttValMap: Record "Item Attribute Value Mapping";
        RecItem: Record Item;
        FinalPostingCode: Code[20];
        FindCategory: Code[20];
        CheckValidation: Boolean;
        AttributeValue: Text[500];
        ItemAttributeValue: Record "Item Attribute Value";
        ItemAttribute: Record "Item Attribute";
    begin
        RecItem.Reset();
        RecItem.SetRange("No.", ItemNo);
        if RecItem.FindFirst() then;

        // To get attibute details
        RecItemAttValMap.Reset();
        RecItemAttValMap.SetRange("Table ID", 27);
        RecItemAttValMap.SetRange("No.", ItemNo);
        if RecItemAttValMap.FindSet() then begin
            repeat
                //New Code Added 09/26/2021+++
                Clear(AttributeValue);
                ItemAttribute.Reset();
                ItemAttribute.SetRange(ID, RecItemAttValMap."Item Attribute ID");
                if ItemAttribute.FindFirst() then begin
                    ItemAttributeValue.SetRange("Attribute ID", ItemAttribute.ID);
                    ItemAttributeValue.SetRange(ID, RecItemAttValMap."Item Attribute Value ID");
                    if ItemAttributeValue.FindFirst() then begin
                        AttributeValue := ItemAttributeValue.Value;
                    end;
                end;


                Clear(CompanyLicenseFound);
                Clear(licenseCopulsary);
                RecLicenseLine.CalcFields(Status);
                //RecLicenseLine.SetCurrentKey("Warning Type");
                RecLicenseLine.Reset();
                //RecLicenseLine.SetRange("Item Category", RecItem."Item Category Code"); //Commented By Abdul++
                RecLicenseLine.SetRange("Item Attribute ID", RecItemAttValMap."Item Attribute ID");
                RecLicenseLine.SetRange("Item Attribute Value ID", RecItemAttValMap."Item Attribute Value ID");
                RecLicenseLine.SetRange(Status, RecLicenseLine.Status::Release);
                RecLicenseLine.SetRange(Mandatory, true);
                //RecLicenseLine.SetAscending("Warning Type", false);
                if RecLicenseLine.FindSet() then begin
                    repeat
                        Clear(FindCategory);
                        CheckValidation := false;
                        RecLicenseLine.CalcFields("Apply to Child Categories");
                        if RecLicenseLine."Apply to Child Categories" = true then begin
                            if RecLicenseLine."Item Category" = RecItem."Item Category Code" then begin
                                FindCategory := RecLicenseLine."Item Category";
                                CheckValidation := true;
                            end else begin
                                if RecLicenseLine."Item Category" = FindParentCategory(RecItem."Item Category Code") then begin
                                    FindCategory := RecLicenseLine."Item Category";
                                    CheckValidation := true;
                                end;
                            end;
                        end else begin
                            if RecLicenseLine."Item Category" = RecItem."Item Category Code" then begin
                                FindCategory := RecLicenseLine."Item Category";
                                CheckValidation := true;
                            end;
                        end;

                        if CheckValidation = true then begin
                            RecLicenseLine.CalcFields("Warning Text", "Warning Type", "Apply To", "Supplier Posting Group", "Customer Posting Group", Country, "Country Validation");
                            /*
                                                //posting group if sale order
                                                Clear(FinalPostingCode);
                                                if CalledFrom = 0 then begin
                                                    FinalPostingCode := RecLicenseLine."Customer Posting Group"
                                                end else begin
                                                    //posting group if Purchase order
                                                    FinalPostingCode := RecLicenseLine."Supplier Posting Group";
                                                end;
                            */
                            Clear(_CompanyLicenseError);
                            Clear(_Attribute);
                            if CalledFrom = CalledFrom::Purchase then begin
                                If RecLicenseLine."Country Validation" = RecLicenseLine."Country Validation"::" " then begin
                                    if (RecLicenseLine."Customer Posting Group" = PostingGroup) and (RecLicenseLine.Country = shippingCountry) then begin
                                        if (RecLicenseLine."Apply To" = RecLicenseLine."Apply To"::Both) or (RecLicenseLine."Apply To" = RecLicenseLine."Apply To"::Purchase) then begin
                                            licenseCopulsary := true;
                                            _CompanyLicenseError := ForIntegration_ValidateCompanyLicense(CalledFrom, CompanyNo, FindCategory, RecItemAttValMap."Item Attribute ID", RecItemAttValMap."Item Attribute Value ID", RecLicenseLine."License Code", PostingGroup, shippingCountry, OrderDate, true, PostCode, ItemNo, AttributeValue);
                                            _Attribute := AttributeValue;
                                        end;
                                    end;
                                end Else Begin
                                    if (RecLicenseLine."Customer Posting Group" = PostingGroup) then begin
                                        if (RecLicenseLine."Apply To" = RecLicenseLine."Apply To"::Both) or (RecLicenseLine."Apply To" = RecLicenseLine."Apply To"::Purchase) then begin
                                            licenseCopulsary := true;
                                            _CompanyLicenseError := ForIntegration_ValidateCompanyLicense(CalledFrom, CompanyNo, FindCategory, RecItemAttValMap."Item Attribute ID", RecItemAttValMap."Item Attribute Value ID", RecLicenseLine."License Code", PostingGroup, shippingCountry, OrderDate, false, PostCode, ItemNo, AttributeValue);
                                            _Attribute := AttributeValue;
                                        end;
                                    end;
                                End;
                            end else begin
                                If RecLicenseLine."Country Validation" = RecLicenseLine."Country Validation"::" " then begin
                                    if (RecLicenseLine."Customer Posting Group" = PostingGroup) and (RecLicenseLine.Country = shippingCountry) then begin
                                        if (RecLicenseLine."Apply To" = RecLicenseLine."Apply To"::Both) or (RecLicenseLine."Apply To" = RecLicenseLine."Apply To"::Sales) then begin
                                            licenseCopulsary := true;
                                            _CompanyLicenseError := ForIntegration_ValidateCompanyLicense(CalledFrom, CompanyNo, FindCategory, RecItemAttValMap."Item Attribute ID", RecItemAttValMap."Item Attribute Value ID", RecLicenseLine."License Code", PostingGroup, shippingCountry, OrderDate, true, PostCode, ItemNo, AttributeValue);
                                            _Attribute := AttributeValue;
                                        end;
                                    end;
                                end Else Begin
                                    if (RecLicenseLine."Customer Posting Group" = PostingGroup) then begin
                                        if (RecLicenseLine."Apply To" = RecLicenseLine."Apply To"::Both) or (RecLicenseLine."Apply To" = RecLicenseLine."Apply To"::Sales) then begin
                                            licenseCopulsary := true;
                                            _CompanyLicenseError := ForIntegration_ValidateCompanyLicense(CalledFrom, CompanyNo, FindCategory, RecItemAttValMap."Item Attribute ID", RecItemAttValMap."Item Attribute Value ID", RecLicenseLine."License Code", PostingGroup, shippingCountry, OrderDate, false, PostCode, ItemNo, AttributeValue);
                                            _Attribute := AttributeValue;
                                        end;
                                    end;
                                End;
                            end;
                        end;
                    until RecLicenseLine.Next = 0;
                end;
            until RecItemAttValMap.Next = 0;
        end;
    end;

    local procedure ForIntegration_ValidateCompanyLicense(CalledFrom: Option "Sales","Purchase"; CompanyNo: code[20]; ItemCatCode: Code[20]; ItemAttrId: Integer; ItemAttrValueId: Integer; LicenseCode: Code[100]; PostingGroup: Code[20]; shippingCountry: Text[30]; OrderDate: Date; countryvalidation: Boolean; PostCode: code[20]; ItemCode: Code[20]; AttributeValue: Text[500]) _ErrorMessage: Text[100]
    var
        ReccomplicensLine: Record "Company License Line";
        RecLicenseLine: Record "License Line";
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        ReccomplicensLine.Reset();
        ReccomplicensLine.SetRange("Company No.", CompanyNo);
        ReccomplicensLine.SetRange("Item Category", ItemCatCode);
        ReccomplicensLine.SetRange("Item Attribute ID", ItemAttrId);
        ReccomplicensLine.SetRange("Item Attribute Value ID", ItemAttrValueId);
        ReccomplicensLine.SetRange("License Code", LicenseCode);
        ReccomplicensLine.SetRange("Posting Group", PostingGroup);
        ReccomplicensLine.CalcFields("Post code");
        if PostCode <> '' then
            ReccomplicensLine.SetRange("Post code", PostCode);
        if countryvalidation then
            ReccomplicensLine.SetRange("Shipping Country", shippingCountry);
        //ReccomplicensLine.SetRange(Mandatory, true);25 feb
        if ReccomplicensLine.FindFirst() then begin
            ReccomplicensLine.CalcFields(Status, "Grant Date", "Expiry Date", "Post code");
            ReccomplicensLine.CalcFields("Post code");
            if ReccomplicensLine."Post code" = PostCode then begin
                if ReccomplicensLine.Status = ReccomplicensLine.Status::Release then begin
                    if (ReccomplicensLine."Grant Date" <= OrderDate) and (ReccomplicensLine."Expiry Date" >= OrderDate) then begin
                        CompanyLicenseFound := true;
                    end else begin
                        //Error('Valid Licence Not Found');
                    end;
                end else begin
                    //Error('Valid Licence Not Found');
                end;
            end else begin
                //Error('Valid Licence Not Found');
            end;
        end else begin
            //Error('Valid Licence Not Found');
        end;

        //New Code Added 09262021+++
        Clear(_ErrorMessage);
        if CompanyLicenseFound = false then begin
            RecLicenseLine.Reset();
            RecLicenseLine.SetRange("License Code", LicenseCode);
            if RecLicenseLine.FindFirst() then begin
                RecLicenseLine.CalcFields("Warning Text", "Warning Type");
                if RecLicenseLine."Warning Type" = RecLicenseLine."Warning Type"::Error then begin
                    _ErrorMessage := StrSubstNo('%1 for Item No.: %2 and Item Attribute: %3', RecLicenseLine."Warning Text", ItemCode, AttributeValue);
                end;
                // if RecLicenseLine."Warning Type" = RecLicenseLine."Warning Type"::Warning then begin
                //     if not ConfirmManagement.GetResponseOrDefault(StrSubstNo('%1 for Item No.: %2 and Item Attribute: %3', RecLicenseLine."Warning Text", ItemCode, AttributeValue), true) then begin
                //         Error('Process Stopped Please Revert Changes');
                //     end else begin
                //     end;
                // end;
                if RecLicenseLine."Warning Type" = RecLicenseLine."Warning Type"::" " then
                    _ErrorMessage := 'License setup manadatory found and valid customer licence not found';
            end;
        end;
        //New Code Added 09262021+++

    end;




    local procedure ValidateCompanyLicense(CalledFrom: Option "Sales","Purchase"; CompanyNo: code[20]; ItemCatCode: Code[20]; ItemAttrId: Integer; ItemAttrValueId: Integer; LicenseCode: Code[100]; PostingGroup: Code[20]; shippingCountry: Text[30]; OrderDate: Date; countryvalidation: Boolean; PostCode: code[20]; ItemCode: Code[20]; AttributeValue: Text[500])
    var
        ReccomplicensLine: Record "Company License Line";
        RecLicenseLine: Record "License Line";
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        ReccomplicensLine.Reset();
        ReccomplicensLine.SetRange("Company No.", CompanyNo);
        ReccomplicensLine.SetRange("Item Category", ItemCatCode);
        ReccomplicensLine.SetRange("Item Attribute ID", ItemAttrId);
        ReccomplicensLine.SetRange("Item Attribute Value ID", ItemAttrValueId);
        //ReccomplicensLine.SetRange("License Code", LicenseCode);
        ReccomplicensLine.SetRange("Posting Group", PostingGroup);
        ReccomplicensLine.CalcFields("Post code");
        if PostCode <> '' then
            ReccomplicensLine.SetRange("Post code", PostCode);
        if countryvalidation then
            ReccomplicensLine.SetRange("Shipping Country", shippingCountry);
        //ReccomplicensLine.SetRange(Mandatory, true);25 feb
        if ReccomplicensLine.FindFirst() then begin
            ReccomplicensLine.CalcFields(Status, "Grant Date", "Expiry Date", "Post code");
            ReccomplicensLine.CalcFields("Post code");
            if ReccomplicensLine."Post code" = PostCode then begin
                if ReccomplicensLine.Status = ReccomplicensLine.Status::Release then begin
                    if (ReccomplicensLine."Grant Date" <= OrderDate) and (ReccomplicensLine."Expiry Date" >= OrderDate) then begin
                        CompanyLicenseFound := true;
                    end else begin
                        //Error('Valid Licence Not Found');
                    end;
                end else begin
                    //Error('Valid Licence Not Found');
                end;
            end else begin
                //Error('Valid Licence Not Found');
            end;
        end else begin
            //Error('Valid Licence Not Found');
        end;

        //New Code Added 09262021+++
        if CompanyLicenseFound = false then begin
            RecLicenseLine.Reset();
            RecLicenseLine.SetRange("License Code", LicenseCode);
            if RecLicenseLine.FindFirst() then begin
                RecLicenseLine.CalcFields("Warning Text", "Warning Type");
                if RecLicenseLine."Warning Type" = RecLicenseLine."Warning Type"::Error then begin
                    Error('%1 for Item No.: %2 and Item Attribute: %3', RecLicenseLine."Warning Text", ItemCode, AttributeValue);
                end;
                if RecLicenseLine."Warning Type" = RecLicenseLine."Warning Type"::Warning then begin
                    if not ConfirmManagement.GetResponseOrDefault(StrSubstNo('%1 for Item No.: %2 and Item Attribute: %3', RecLicenseLine."Warning Text", ItemCode, AttributeValue), true) then begin
                        Error('Process Stopped Please Revert Changes');
                    end else begin
                    end;
                end;
                if RecLicenseLine."Warning Type" = RecLicenseLine."Warning Type"::" " then
                    Error('License setup manadatory found and valid customer licence not found');
            end;
        end;
        //New Code Added 09262021+++

    end;

    procedure Exist_Header(_ComplicensLine: Record "Company License Line"): Boolean
    var
        L_CompanyLicenseHeader: Record "Company License Header";
    begin
        L_CompanyLicenseHeader.Reset();
        L_CompanyLicenseHeader.SetRange("Company No.", _ComplicensLine."Company No.");
        L_CompanyLicenseHeader.SetRange("License No.", _ComplicensLine."License No.");
        L_CompanyLicenseHeader.SetRange("License Code", _ComplicensLine."License Code");
        if not L_CompanyLicenseHeader.IsEmpty then
            exit(true)
        else
            exit(false);
    end;



    trigger OnRun()
    begin

    end;

    /*EventSubscriberInstance = StaticAutomatic;
  [EventSubscriber(ObjectType::Table, 37, 'OnBeforeValidateEvent', 'No.', true, true)]
  local procedure CheckingLicenseSales(var Rec: Record "Sales Line")
  var
      RecLicenceHeader: Record "License Header";
      Reccomplicensheader: Record CompLicenseheader;
      RecLicenseLine: Record "License Line";
      ReccomplicensLine: Record Complicenseline;
      RecItemAttValMap: Record "Item Attribute Value Mapping";
      RecSalesHeader: Record "Sales Header";
      RecItem: Record Item;
      licenseCopulsaru: Boolean;
      LicenseFound: Boolean;

  begin
      // Message('inside event');//salman
      if Rec.Type = Rec.Type::Item then begin
          //to get post code and custpostgrp
          RecSalesHeader.Reset();
          RecSalesHeader.SetRange("No.", Rec."Document No.");
          if RecSalesHeader.FindFirst() then begin

          end;
          // Message(RecSalesHeader."No.");//salman
          RecItem.Reset();
          RecItem.SetRange("No.", Rec."No.");
          if RecItem.FindFirst() then;
          // Message(RecItem."Item Category Code");//salman

          Clear(licenseCopulsaru);
          Clear(LicenseFound);
          // To get attibute details
          RecItemAttValMap.Reset();
          RecItemAttValMap.SetRange("Table ID", 27);
          RecItemAttValMap.SetRange("No.", Rec."No.");
          if RecItemAttValMap.FindSet() then begin
              repeat
                  // Message('inside item val maping loop');//salman
                  //Message(format(RecItemAttValMap."Item Attribute ID") + Format(RecItemAttValMap."Item Attribute Value ID"));
                  RecLicenseLine.Reset();
                  RecLicenseLine.SetRange("Item Category", RecItem."Item Category Code");
                  RecLicenseLine.SetRange("Item Attribute ID", RecItemAttValMap."Item Attribute ID");
                  RecLicenseLine.SetRange("Item Attribute Value ID", RecItemAttValMap."Item Attribute Value ID");
                  RecLicenseLine.SetRange(Mandatory, true);
                  if RecLicenseLine.FindSet() then begin
                      RecLicenseLine.CalcFields("Apply To", "Customer Posting Group", Country);
                      if (RecLicenseLine."Customer Posting Group" = RecSalesHeader."Customer Posting Group") and (RecLicenseLine.Country = RecSalesHeader."Ship-to Country/Region Code") then begin
                          //Message(format(RecItemAttValMap."Item Attribute ID"));

                          if (RecLicenseLine."Apply To" = RecLicenseLine."Apply To"::Both) or (RecLicenseLine."Apply To" = RecLicenseLine."Apply To"::Sales) then begin
                              // Message('inside licence line loop');//salman
                              //licenseCopulsaru := true;//7jan2021 
                              //  Message(format(licenseCopulsaru));
                              ReccomplicensLine.Reset();

                              ReccomplicensLine.SetRange("Company No.", RecSalesHeader."Sell-to Customer No.");//7jan2021 
                              ReccomplicensLine.SetRange("Item Category", RecItem."Item Category Code");
                              ReccomplicensLine.SetRange("Item Attribute ID", RecItemAttValMap."Item Attribute ID");
                              ReccomplicensLine.SetRange("Item Attribute Value ID", RecItemAttValMap."Item Attribute Value ID");
                              ReccomplicensLine.SetRange("License Code", RecLicenseLine."License Code");
                              ReccomplicensLine.SetRange("Customer Posting Group", RecSalesHeader."Customer Posting Group");
                              ReccomplicensLine.SetRange("Shipping Country", RecSalesHeader."Ship-to Country/Region Code");
                              ReccomplicensLine.SetRange(Mandatory, true);
                              if ReccomplicensLine.FindFirst() then begin
                                  //Message('inside comp line loop');//salman
                                  //ReccomplicensLine.
                                  ReccomplicensLine.CalcFields(Status, "Grant Date", "Expiry Date");
                                  if ReccomplicensLine.Status = ReccomplicensLine.Status::Release then begin
                                      if (ReccomplicensLine."Grant Date" <= RecSalesHeader."Order Date") and (ReccomplicensLine."Expiry Date" >= RecSalesHeader."Order Date") then begin
                                          //LicenseFound := true;//7jan2021 
                                          //Message(Format(LicenseFound));

                                      end else begin//7jan2021
                                          Error('Valid Licence Not Found');//7jan2021 
                                      end;

                                  end else begin//7jan2021
                                      Error('Valid Licence Not Found');//7jan2021 
                                  end;

                              end else begin//7jan2021 
                                  //Message('hi');
                                  //Message('outside complincese line loop');
                                  Error('Valid Licence Not Found');//7jan2021 
                              end;
                          end;
                      end;
                  end;
              until RecItemAttValMap.Next = 0;
              /*7jan2021 
                              if licenseCopulsaru = true then begin
                                  if LicenseFound = false then begin
                                      Error('Valid Licence Not Found');
                                  end;
                              end;       end;
      end;

  end;*/

    /*[EventSubscriber(ObjectType::Table, 39, 'OnBeforeValidateEvent', 'No.', true, true)]
    local procedure CheckingLicensePurh(var Rec: Record "Purchase Line")
    var
        RecLicenceHeader: Record "License Header";
        Reccomplicensheader: Record CompLicenseheader;
        RecLicenseLine: Record "License Line";
        ReccomplicensLine: Record Complicenseline;
        RecItemAttValMap: Record "Item Attribute Value Mapping";
        RecPurchHeader: Record "Purchase Header";
        RecItem: Record Item;
        licenseCopulsaru: Boolean;
        LicenseFound: Boolean;

    begin
        if Rec.Type = Rec.Type::Item then begin
            //to get post code and custpostgrp
            RecPurchHeader.Reset();
            RecPurchHeader.SetRange("No.", Rec."Document No.");
            if RecPurchHeader.FindFirst() then begin

            end;

            RecItem.Reset();
            RecItem.SetRange("No.", Rec."No.");
            if RecItem.FindFirst() then;

            Clear(licenseCopulsaru);
            Clear(LicenseFound);
            // To get attibute details
            RecItemAttValMap.Reset();
            RecItemAttValMap.SetRange("Table ID", 27);
            RecItemAttValMap.SetRange("No.", Rec."No.");
            if RecItemAttValMap.FindSet() then begin
                repeat
                    //Message(format(RecItemAttValMap."Item Attribute ID") + Format(RecItemAttValMap."Item Attribute Value ID"));
                    RecLicenseLine.Reset();
                    RecLicenseLine.SetRange("Item Category", RecItem."Item Category Code");
                    RecLicenseLine.SetRange("Item Attribute ID", RecItemAttValMap."Item Attribute ID");
                    RecLicenseLine.SetRange("Item Attribute Value ID", RecItemAttValMap."Item Attribute Value ID");
                    RecLicenseLine.SetRange(Mandatory, true);
                    if RecLicenseLine.FindSet() then begin
                        RecLicenseLine.CalcFields("Apply To", "Customer Posting Group", Country);
                        if (RecLicenseLine."Customer Posting Group" = RecPurchHeader."Vendor Posting Group") and (RecLicenseLine.Country = RecPurchHeader."Buy-from Country/Region Code") then begin
                            //Message(format(RecItemAttValMap."Item Attribute ID"));

                            if (RecLicenseLine."Apply To" = RecLicenseLine."Apply To"::Both) or (RecLicenseLine."Apply To" = RecLicenseLine."Apply To"::Purchase) then begin
                                //licenseCopulsaru := true;//7jan2021 
                                //  Message(format(licenseCopulsaru));
                                ReccomplicensLine.Reset();
                                ReccomplicensLine.SetRange("Company No.", RecPurchHeader."Buy-from Vendor No.");//7jan2021 
                                ReccomplicensLine.SetRange("Item Category", RecItem."Item Category Code");
                                ReccomplicensLine.SetRange("Item Attribute ID", RecItemAttValMap."Item Attribute ID");
                                ReccomplicensLine.SetRange("Item Attribute Value ID", RecItemAttValMap."Item Attribute Value ID");
                                ReccomplicensLine.SetRange("License Code", RecLicenseLine."License Code");
                                ReccomplicensLine.SetRange("Customer Posting Group", RecPurchHeader."Vendor Posting Group");
                                ReccomplicensLine.SetRange("Shipping Country", RecPurchHeader."Buy-from Country/Region Code");
                                ReccomplicensLine.SetRange(Mandatory, true);
                                if ReccomplicensLine.FindFirst() then begin
                                    ReccomplicensLine.CalcFields(Status, "Grant Date", "Expiry Date");
                                    if ReccomplicensLine.Status = ReccomplicensLine.Status::Release then begin
                                        if (ReccomplicensLine."Grant Date" <= RecPurchHeader."Order Date") and (ReccomplicensLine."Expiry Date" >= RecPurchHeader."Order Date") then begin
                                            //LicenseFound := true;//7jan2021 
                                            //Message(Format(LicenseFound));
                                        end else begin//7jan2021 
                                            Error('Valid Licence Not Found');//7jan2021 
                                        end;
                                    end else begin//7jan2021 
                                        Error('Valid Licence Not Found');//7jan2021 
                                    end;
                                end else begin//7jan2021 
                                    Error('Valid Licence Not Found');//7jan2021 
                                end;
                            end;
                        end;
                    end;
                until RecItemAttValMap.Next = 0;
                /*7jan2021
                                if licenseCopulsaru = true then begin
                                    if LicenseFound = false then begin
                                        Error('Valid Licence Not Found');
                                    end;
                                end;7jan2021
            end;
        end;
    end;*/


    var
        myInt: Integer;
        CompanyLicenseFound: Boolean;
        licenseCopulsary: Boolean;




    local procedure FindParentCategory(ChildCategory: Code[20]): code[20]
    var
        L_ItemCategory: Record "Item Category";
        CategoryCode: Code[20];
        Loop_ParentCategoryCode: Code[20];
    begin
        // L_ItemCategory.Reset();
        // //L_ItemCategory.SetRange("Parent Category", ChildCategory);//Wrong code commneted Azhar
        // L_ItemCategory.SetRange(Code, ChildCategory);//Right Code Added Azhar
        // if L_ItemCategory.FindFirst() then
        //     exit(L_ItemCategory."Parent Category");//Right Code Added Azhar
        // //exit(L_ItemCategory.Code);//Wrong code commneted Azhar


        //The below code is only for SIGMA Process++
        //Check the first Parent category code of Child Category++
        Clear(Loop_ParentCategoryCode);
        Clear(CategoryCode);
        L_ItemCategory.Reset();
        L_ItemCategory.SetRange(Code, ChildCategory);
        if L_ItemCategory.FindFirst() then begin
            Loop_ParentCategoryCode := L_ItemCategory."Parent Category";
            CategoryCode := L_ItemCategory."Parent Category";
        end;

        //Find the last parent category Code++
        repeat
            L_ItemCategory.Reset();
            if L_ItemCategory.Get(Loop_ParentCategoryCode) then begin
                Loop_ParentCategoryCode := L_ItemCategory."Parent Category";
                if L_ItemCategory."Parent Category" <> '' then
                    CategoryCode := L_ItemCategory."Parent Category";
            end else
                Loop_ParentCategoryCode := '';
        until Loop_ParentCategoryCode = '';
        exit(CategoryCode);
    end;


}