codeunit 50101 "Object Details Install"
{
    Subtype = Install;
    trigger OnInstallAppPerCompany()
    var
        ObjectDetails: Record "Object Details";
    begin
        if ObjectDetails.IsEmpty() then
            InitializeObjects();
    end;

    local procedure InitializeObjects()
    var
        AllObj: Record AllObj;
    begin
        InsertNewRecords("Object Type"::Table, AllObj."Object Type"::Table);
        InsertNewRecords("Object Type"::"TableExtension", AllObj."Object Type"::"TableExtension");
        InsertNewRecords("Object Type"::Page, AllObj."Object Type"::Page);
        InsertNewRecords("Object Type"::"PageExtension", AllObj."Object Type"::"PageExtension");
        InsertNewRecords("Object Type"::Report, AllObj."Object Type"::Report);
        InsertNewRecords("Object Type"::Codeunit, AllObj."Object Type"::Codeunit);
        InsertNewRecords("Object Type"::Enum, AllObj."Object Type"::Enum);
        InsertNewRecords("Object Type"::EnumExtension, AllObj."Object Type"::EnumExtension);
        InsertNewRecords("Object Type"::XMLPort, AllObj."Object Type"::XMLport);
        InsertNewRecords("Object Type"::Query, AllObj."Object Type"::Query);
        InsertNewRecords("Object Type"::MenuSuite, AllObj."Object Type"::MenuSuite);
    end;

    local procedure InsertNewRecords(ObjectTypeObjectDetails: Enum "Object Type"; ObjectTypeAllObj: Integer)
    var
        AllObj: Record AllObj;
        ObjectDetails: Record "Object Details";
    begin
        AllObj.SetRange("Object Type", ObjectTypeAllObj);
        if AllObj.FindFirst() then
            repeat
                ObjectDetails.Init();
                ObjectDetails.Validate(ObjectType, ObjectTypeObjectDetails);
                ObjectDetails.Validate(ObjectNo, AllObj."Object ID");
                ObjectDetails.Insert(true);
            until AllObj.Next() = 0;
    end;

}