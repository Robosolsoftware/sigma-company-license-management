page 60558 "License Sync Log"
{
    Caption = 'License Sync Log';
    PageType = List;
    SourceTable = "License Sync Log";
    ApplicationArea = all;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("License No."; Rec."License No.")
                {
                    ApplicationArea = All;
                }
                field("Sync DateTime"; Rec."Sync DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Date and time the sync was performed.';
                }
                field("Synced By"; Rec."Synced By")
                {
                    ApplicationArea = All;
                    ToolTip = 'User who triggered the sync.';
                }
                field("Field Name"; Rec."Field Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'The field that was changed during sync.';
                    StyleExpr = FieldStyle;
                }
                field("Old Value"; Rec."Old Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Value before the sync.';
                }
                field("New Value"; Rec."New Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Value after the sync.';
                    StyleExpr = FieldStyle;
                }
                field("Sync Status"; Rec."Sync Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Whether the sync succeeded or failed.';
                    StyleExpr = StatusStyle;
                }
                field("HTTP Status"; Rec."HTTP Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'HTTP status code returned by the Sigma TraxQM API.';
                    //Visible = false;
                }
                field("Error Message"; Rec."Error Message")
                {
                    ApplicationArea = All;
                    ToolTip = 'Error details if the sync failed.';
                    //Visible = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ShowAllEntries)
            {
                Caption = 'Show All Entries';
                ApplicationArea = All;
                Image = Log;
                ToolTip = 'Remove the license filter and show all sync log entries.';

                trigger OnAction()
                begin
                    Rec.SetRange("License No.");
                    CurrPage.Update(false);
                end;
            }
            action(ClearLog)
            {
                Caption = 'Clear Log';
                ApplicationArea = All;
                Image = Delete;
                ToolTip = 'Delete all log entries for the currently filtered license.';

                trigger OnAction()
                var
                    LogEntry: Record "License Sync Log";
                    ConfirmMsg: Label 'Are you sure you want to delete all log entries for License %1? This cannot be undone.';
                    LicenseNoFilter: Code[20];
                begin
                    LicenseNoFilter := CopyStr(Rec.GetFilter("License No."), 1, 20);
                    if LicenseNoFilter <> '' then begin
                        if not Confirm(ConfirmMsg, false, LicenseNoFilter) then
                            exit;
                        LogEntry.SetRange("License No.", LicenseNoFilter);
                    end else begin
                        if not Confirm('Are you sure you want to delete ALL sync log entries?', false) then
                            exit;
                    end;

                    LogEntry.DeleteAll();
                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        FieldStyle: Text;
        StatusStyle: Text;

    trigger OnAfterGetRecord()
    begin
        // Highlight rows where values actually changed
        if Rec."Old Value" <> Rec."New Value" then
            FieldStyle := 'Favorable'
        else
            FieldStyle := 'Standard';

        case Rec."Sync Status" of
            Rec."Sync Status"::Success:
                StatusStyle := 'Favorable';
            Rec."Sync Status"::Failed:
                StatusStyle := 'Unfavorable';
            Rec."Sync Status"::"Token Refreshed":
                StatusStyle := 'Ambiguous';
        end;
    end;
}
