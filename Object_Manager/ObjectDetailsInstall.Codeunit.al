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
        AddFieldsToObjectDetailsLine();
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

    local procedure AddFieldsToObjectDetailsLine()
    var
        AllObj: Record AllObj;
        Field: Record Field;
        ObjectDetailsLine: Record "Object Details Line";
        SystemTableIDs: Integer;
    begin
        SystemTableIDs := 2000000000;
        AllObj.SetRange("Object Type", AllObj."Object Type"::Table);
        if AllObj.FindFirst() then
            repeat
                Field.SetRange(TableNo, AllObj."Object ID");
                if Field.FindFirst() then
                    repeat
                        if Field."No." < SystemTableIDs then
                            InsertObjectDetailsLine(Field, "Object Type"::Table);
                    until Field.Next() = 0;
            until AllObj.Next() = 0;
    end;

    local procedure InsertObjectDetailsLine(var Field: Record Field; ObjectType: Enum "Object Type")
    var
        ObjectDetailsLine: Record "Object Details Line";
    begin
        ObjectDetailsLine.Init();
        ObjectDetailsLine.EntryNo := 0;
        ObjectDetailsLine.Validate(ObjectType, ObjectType);
        ObjectDetailsLine.Validate(ObjectNo, Field.TableNo);
        ObjectDetailsLine.Validate(Type, Types::Field);
        ObjectDetailsLine.Validate(ID, Field."No.");
        ObjectDetailsLine.Insert(true);
    end;

}