page 50090 "Lookup Values APIV1"
{
    Caption = 'lookupValues', Locked = true;
    SourceTable = LookupValue;
    PageType = API;
    APIVersion = 'v1.0';
    APIGroup = 'automation';
    APIPublisher = 'fluxxus';
    EntityName = 'lookupValue';
    EntitySetName = 'lookupValues';
    ODataKeyFields = SystemId;
    ChangeTrackingAllowed = true;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'id', Locked = true;
                    Editable = false;
                }
                field(number; Rec.Code)
                {
                    Caption = 'number', Locked = true;
                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo(Code));
                    end;
                }
                field(displayName; Rec.Description)
                {
                    Caption = 'displayName', Locked = true;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        if Rec.Description = '' then
                            Error(BlankNameErr);
                        RegisterFieldSet(Rec.FieldNo(Description));
                    end;
                }
            }
        }
    }

    var
        TempFieldSet: Record 2000000041 temporary;
        GraphMgtGeneralTools: Codeunit "Graph Mgt - General Tools";
        NotProvidedNameErr: Label 'A "displayName" must be provided.', Locked = true;
        BlankNameErr: Label 'The blank "displayName" is not allowed.', Locked = true;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        LookupValue: Record LookupValue;
        RecRef: RecordRef;
    begin
        if Rec.Description = '' then
            Error(NotProvidedNameErr);

        LookupValue.SetRange(Code, Rec.Code);
        if not LookupValue.IsEmpty() then
            Rec.Insert();

        Rec.Insert(true);

        RecRef.GetTable(Rec);
        GraphMgtGeneralTools.ProcessNewRecordFromAPI(RecRef, TempFieldSet, CurrentDateTime);
        RecRef.SetTable(Rec);

        Rec.Modify(true);
        exit(false);
    end;

    trigger OnModifyRecord(): Boolean
    var
        LookupValue: Record LookupValue;
    begin
        LookupValue.GetBySystemId(Rec.SystemId);

        if Rec.Code = LookupValue.Code then
            Rec.Modify(true)
        else begin
            LookupValue.TransferFields(Rec, false);
            LookupValue.Rename(Rec.Code);
            Rec.TransferFields(LookupValue);
        end;
    end;

    local procedure RegisterFieldSet(FieldNo: Integer)
    begin
        if TempFieldSet.Get(Database::LookupValue, FieldNo) then
            exit;

        TempFieldSet.Init();
        TempFieldSet.TableNo := Database::LookupValue;
        TempFieldSet.Validate("No.", FieldNo);
        TempFieldSet.Insert(true);
    end;
}