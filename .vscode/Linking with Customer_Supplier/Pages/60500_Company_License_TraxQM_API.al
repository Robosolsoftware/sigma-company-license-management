page 60557 Company_License_TraxQM_API
{
    PageType = API;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Company License Header";
    SourceTableView = where("License Code" = const('GPHC'));
    APIPublisher = 'Robosol';
    APIGroup = 'TraxQM';
    APIVersion = 'v2.0';
    EntitySetName = 'headers';
    EntityName = 'header';
    Permissions = tabledata "Company License Header" = RIMD;
    DelayedInsert = true;
    ModifyAllowed = true;
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("licenseNo"; rec."License No.")
                {

                }
                field("licenseCode"; rec."License Code")
                {

                }
                field(Verification_Date; Rec."Verification Date")
                {

                }
                field("Verified_By"; rec."Verified By")
                {

                }
                field(Expiry_Date; Rec."Expiry Date")
                {

                }
                field(Review_Date; Rec."Review Date")
                {

                }
                field(Synced; Rec.Synced)
                {

                }
            }
        }
    }

}