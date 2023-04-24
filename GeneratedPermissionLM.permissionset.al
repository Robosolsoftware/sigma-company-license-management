permissionset 60500 GeneratedPermLM
{
    Assignable = true;
    Permissions = tabledata "Company License Header"=RIMD,
        tabledata "Company License Line"=RIMD,
        tabledata "License Header"=RIMD,
        tabledata "License Line"=RIMD,
        table "Company License Header"=X,
        table "Company License Line"=X,
        table "License Header"=X,
        table "License Line"=X,
        codeunit "Check Item License"=X,
        page "Company License Header Card"=X,
        page "Company License Header List"=X,
        page "Company License Line Subform"=X,
        page "License Header Card"=X,
        page "License Header List"=X,
        page "License Line Subform"=X;
}