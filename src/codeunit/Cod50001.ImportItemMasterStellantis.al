codeunit 50001 "Import Item Master Stellantis"
{
    TableNo = "Manufacturer Master Versions";
    trigger OnRun()
    var
        FileL: File;
        FileRecL: Record File;
        MakeCodeL: Code[10];
    begin
        if GuiAllowed then
            DialogG.Open(AMECC003 + AMECC004);

        FileRecL.Reset();
        FileRecL.SetFilter(Path, Importpath);
        FileRecL.SetRange("Is a file", true);
        if ("Filename Template" > '') then
            FileRecL.SetFilter(Name, '%1', "Filename Template");
        if FileRecL.FindSet() then begin
            repeat
                if SpecialFuncG.CopyToWorkpath(FileRecL.Path, Workpath, FileRecL.Name) then begin
                    FileL.TextMode(true);
                    FileL.WriteMode(false);
                    FileL.Open(Workpath + FileRecL.Name, TextEncoding::Windows);
                    repeat
                        Clear(RecordTextG);
                        FileL.Read(RecordTextG);
                        ClearVariablesP();
                        ImportVariablesP();
                        if ValidRecordP() then begin
                            MakeCodeL := '';
                            ManufacturerG.Get("Manufacturer Code");
                            MakeCodeL := SpecialFuncG.GetPartsLogiMapping("Manufacturer Code", 0, "Master Code", BusinessSectorG);
                            if GuiAllowed then begin
                                DialogG.Update(1, PartNumberG);
                                DialogG.Update(2, MakeCodeL);
                            end;
                            ImportItemRecordP(MakeCodeL, ManufacturerG."Vendor No. Warehouse", ManufacturerG."Default Unit of Measure");
                        end;
                    until FileL.Pos = FileL.Len;
                    FileL.Close();
                    if not SpecialFuncG.ArchiveFile(FileRecL.Path, Workpath, FileRecL.Name, FileRecL.Name, Archivpath, '') then
                        Error(AMECC001);
                end;
            until FileRecL.Next() = 0;

            if GuiAllowed then
                DialogG.Close();
        end;


    end;

    local procedure ClearVariablesP()
    begin
        Clear(DistributionTypeG);
        Clear(DistributionDateG);
        Clear(AppDateG);
        Clear(SalesOrganisationG);
        Clear(CountryG);
        Clear(PriceListG);
        Clear(PriceListTypeG);
        Clear(CurrencyG);
        Clear(PartNumberG);
        Clear(Designation1G);
        Clear(Designation2G);
        Clear(BusinessSectorG);
        Clear(TypeCodeG);
        Clear(TaxCategoryG);
        Clear(NetPriceIndicatorG);
        Clear(UnitPurchPriceExVATG);
        Clear(UnitSalesPriceExVATG);
        Clear(ReplacementCodeG);
        Clear(ListNumberG);
        Clear(ReplacementPartG);
        Clear(PackagingQtyG);
        Clear(NetWeightG);
        Clear(ItemDiscountCode);
        Clear(RebateCodeG);
        Clear(CustTARICCodeG);
        Clear(IndexBusiLineG);
        Clear(SegmentG);
        Clear(SlotMacrofamG);
        Clear(MarketingFamilyG);
        Clear(BasketG);
        Clear(ProvSurchagePartG);
        Clear(SellPriceOfProvisionexVATG);
        Clear(StdExchangeFlagG);
        Clear(PartoriginG);
        Clear(DMSFormatReferenceG);
        Clear(MainReplCompQtyG);
        Clear(ReplCompNo2G);
        Clear(ReplCompQty2G);
        Clear(ReplCompNo3G);
        Clear(ReplCompQty3G);
        Clear(ReplCompNo4G);
        Clear(ReplCompQty4G);
        Clear(ReplCompNo5G);
        Clear(ReplCompQty5G);
        Clear(ReplCompNo6G);
        Clear(ReplCompQty6G);
        Clear(ADVStatusG);
        Clear(MatModificationCatG);
        Clear(Designation3G);
        Clear(Designation4G);
        Clear(SellingFreqG);
        Clear(ProcurementFamG);
        Clear(GTING);
        Clear(IAMDiscCodeG);
        Clear(HazardousGoodsFlagG);
        Clear(IAMIndicatorG);
        Clear(SellbyDateIndG);
        Clear(StorageDurationG);
        Clear(CTUG);
        Clear(TyreFamilyG);
        Clear(TyreDimensionsG);
        Clear(TyreTradeNameG);
        Clear(LengthG);
        Clear(MaterialWidthG);
        Clear(HeightG);
        Clear(VolumeG);
        Clear(IdentCharacteristicG);
        Clear(LongDescG);
        Clear(FuelEffG);
        Clear(RoadQualityOnWetRoad);
        Clear(ExtDrivingNoiseG);
        Clear(SoundWaveClassG);
    end;

    local procedure ImportVariablesP()
    var
        HelpDateTextL: Text[8];
        YearL: Integer;
        MonthL: Integer;
        DayL: Integer;
    begin
        DistributionTypeG := CopyStr(RecordTextG, 1, 3);
        Clear(HelpDateTextL);
        DayL := 0;
        MonthL := 0;
        YearL := 0;
        HelpDateTextL := CopyStr(RecordTextG, 4, 8);
        Evaluate(DayL, CopyStr(HelpDateTextL, 7, 2));
        Evaluate(MonthL, CopyStr(HelpDateTextL, 5, 2));
        Evaluate(YearL, CopyStr(HelpDateTextL, 1, 4));
        DistributionDateG := DMY2Date(DayL, MonthL, YearL);
        Clear(HelpDateTextL);
        DayL := 0;
        MonthL := 0;
        YearL := 0;
        HelpDateTextL := CopyStr(RecordTextG, 12, 8);
        Evaluate(DayL, CopyStr(HelpDateTextL, 7, 2));
        Evaluate(MonthL, CopyStr(HelpDateTextL, 5, 2));
        Evaluate(YearL, CopyStr(HelpDateTextL, 1, 4));
        AppDateG := DMY2Date(DayL, MonthL, YearL);
        SalesOrganisationG := CopyStr(RecordTextG, 20, 4);
        CountryG := DelChr(CopyStr(RecordTextG, 24, 3), '<>', ' ');
        PriceListG := CopyStr(RecordTextG, 27, 2);
        PriceListTypeG := CopyStr(RecordTextG, 29, 1);
        CurrencyG := DelChr(CopyStr(RecordTextG, 30, 5), '<>', ' ');
        PartNumberG := DelChr(CopyStr(RecordTextG, 35, 18), '<>', ' ');
        Designation1G := DelChr(CopyStr(RecordTextG, 53, 15), '<>', ' ');
        Designation2G := DelChr(CopyStr(RecordTextG, 68, 15), '<>', ' ');
        BusinessSectorG := CopyStr(RecordTextG, 83, 1);
        TypeCodeG := DelChr(CopyStr(RecordTextG, 84, 3), '<>', ' ');
        TaxCategoryG := CopyStr(RecordTextG, 87, 1);
        NetPriceIndicatorG := CopyStr(RecordTextG, 88, 1);
        Evaluate(UnitPurchPriceExVATG, Copystr(RecordTextG, 89, 11));
        UnitPurchPriceExVATG := UnitPurchPriceExVATG / 100;
        Evaluate(UnitSalesPriceExVATG, CopyStr(RecordTextG, 100, 11));
        UnitSalesPriceExVATG := UnitSalesPriceExVATG / 100;
        ReplacementCodeG := CopyStr(RecordTextG, 111, 1);
        ListNumberG := DelChr(CopyStr(RecordTextG, 112, 7), '<>', ' ');
        ReplacementPartG := DelChr(CopyStr(RecordTextG, 119, 18), '<>', ' ');
        Evaluate(PackagingQtyG, CopyStr(RecordTextG, 137, 5));
        Evaluate(NetWeightG, CopyStr(RecordTextG, 142, 15));
        ItemDiscountCode := CopyStr(RecordTextG, 157, 2);
        RebateCodeG := CopyStr(RecordTextG, 159, 3);
        CustTARICCodeG := DelChr(CopyStr(RecordTextG, 162, 17), '<>', ' ');
        IndexBusiLineG := DelChr(CopyStr(RecordTextG, 179, 4), '<>', ' ');
        SegmentG := DelChr(CopyStr(RecordTextG, 183, 4), '<>', ' ');
        SlotMacrofamG := DelChr(CopyStr(RecordTextG, 187, 5), '<>', ' ');
        MarketingFamilyG := DelChr(CopyStr(RecordTextG, 192, 5), '<>', ' ');
        BasketG := CopyStr(RecordTextG, 197, 1);
        ProvSurchagePartG := DelChr(CopyStr(RecordTextG, 198, 18), '<>', ' ');
        Evaluate(SellPriceOfProvisionexVATG, CopyStr(RecordTextG, 216, 11));
        SellPriceOfProvisionexVATG := SellPriceOfProvisionexVATG / 100;
        StdExchangeFlagG := CopyStr(RecordTextG, 227, 1);
        PartoriginG := CopyStr(RecordTextG, 228, 1);
        DMSFormatReferenceG := DelChr(CopyStr(RecordTextG, 230, 13), '<>', ' ');
        Evaluate(MainReplCompQtyG, CopyStr(RecordTextG, 248, 6));
        ReplCompNo2G := DelChr(CopyStr(RecordTextG, 254, 18), '<>', ' ');
        Evaluate(ReplCompQty2G, CopyStr(RecordTextG, 272, 6));
        ReplCompNo3G := DelChr(CopyStr(RecordTextG, 278, 18), '<>', ' ');
        Evaluate(ReplCompQty3G, CopyStr(RecordTextG, 296, 6));
        ReplCompNo4G := DelChr(CopyStr(RecordTextG, 302, 18), '<>', ' ');
        Evaluate(ReplCompQty4G, CopyStr(RecordTextG, 320, 6));
        ReplCompNo5G := DelChr(CopyStr(RecordTextG, 326, 18), '<>', ' ');
        Evaluate(ReplCompQty5G, CopyStr(RecordTextG, 344, 6));
        ReplCompNo6G := DelChr(CopyStr(RecordTextG, 350, 18), '<>', ' ');
        Evaluate(ReplCompQty6G, CopyStr(RecordTextG, 368, 6));
        ADVStatusG := CopyStr(RecordTextG, 374, 2);
        MatModificationCatG := CopyStr(RecordTextG, 379, 1);
        Designation3G := CopyStr(RecordTextG, 380, 15);
        Designation4G := CopyStr(RecordTextG, 395, 15);
        SellingFreqG := CopyStr(RecordTextG, 410, 2);
        ProcurementFamG := CopyStr(RecordTextG, 412, 3);
        GTING := DelChr(CopyStr(RecordTextG, 415, 13), '<>', ' ');
        IAMDiscCodeG := DelChr(CopyStr(RecordTextG, 428, 6), '<>', ' ');
        HazardousGoodsFlagG := CopyStr(RecordTextG, 434, 1);
        IAMIndicatorG := CopyStr(RecordTextG, 446, 1);
        SellbyDateIndG := CopyStr(RecordTextG, 447, 1);
        Evaluate(StorageDurationG, CopyStr(RecordTextG, 448, 3));
        Evaluate(CTUG, CopyStr(RecordTextG, 451, 5));
        TyreFamilyG := DelChr(CopyStr(RecordTextG, 456, 3), '<>', ' ');
        TyreDimensionsG := DelChr(CopyStr(RecordTextG, 459, 26), '<>', ' ');
        TyreTradeNameG := DelChr(CopyStr(RecordTextG, 485, 31), '<>', ' ');
        Evaluate(LengthG, CopyStr(RecordTextG, 516, 15));
        LengthG := LengthG / 1000;
        Evaluate(MaterialWidthG, CopyStr(RecordTextG, 531, 15));
        MaterialWidthG := MaterialWidthG / 1000;
        Evaluate(HeightG, CopyStr(RecordTextG, 546, 15));
        HeightG := HeightG / 1000;
        Evaluate(VolumeG, CopyStr(RecordTextG, 561, 15));
        VolumeG := VolumeG / 1000;
        IdentCharacteristicG := DelChr(CopyStr(RecordTextG, 576, 30), '<>', ' ');
        LongDescG := DelChr(CopyStr(RecordTextG, 606, 30), '<>', ' ');
        FuelEffG := CopyStr(RecordTextG, 636, 1);
        RoadQualityOnWetRoad := CopyStr(RecordTextG, 637, 1);
        Evaluate(ExtDrivingNoiseG, CopyStr(RecordTextG, 638, 3));
        SoundWaveClassG := CopyStr(RecordTextG, 641, 1);
    end;

    local procedure ValidRecordP(): Boolean
    begin
        IF (DistributionTypeG <> 'ALD') AND (DistributionTypeG <> 'AUT') THEN BEGIN
            EXIT(FALSE)
        END ELSE BEGIN
            IF (CountryG <> 'DE') THEN
                EXIT(FALSE);
            IF (BusinessSectorG <> 'P') AND (BusinessSectorG <> 'W') AND (BusinessSectorG <> 'C') THEN
                EXIT(FALSE);
            IF (PriceListG <> '03') THEN
                EXIT(FALSE);
            IF (PriceListTypeG <> 'A') THEN
                EXIT(FALSE);
            IF (CurrencyG <> 'EUR') THEN
                EXIT(FALSE);
            IF (TaxCategoryG = '0') OR (TaxCategoryG = '7') OR (TaxCategoryG = '') THEN
                EXIT(FALSE);
        END;
        IF (STRLEN(PartNumberG) = 0) THEN
            EXIT(FALSE);
        EXIT(TRUE);
    end;

    local procedure ImportItemRecordP(ManufacturerP: Code[10]; VendorNoP: Code[20]; UnitOfMeasure: Code[10])
    var
        CatalogItemL: Record "Nonstock Item";
        CatalogItem2L: Record "Nonstock Item";
        AddCatItemDataL: Record "Additional Catalog Item Data";
        AddCatItemData2L: Record "Additional Catalog Item Data";
    begin
        CatalogItem2L.Reset();
        CatalogItem2L.SetCurrentKey("Vendor Item No.", "Manufacturer Code");
        CatalogItem2L.SetRange("Vendor Item No.", PartNumberG);
        CatalogItem2L.SetRange("Manufacturer Code", ManufacturerP);
        if not CatalogItem2L.FindFirst() then begin
            CatalogItemL.Init();
            CatalogItemL."Vendor Item No." := PartNumberG;
            CatalogItemL."Manufacturer Code" := ManufacturerP;
            CatalogItemL.Insert(true);
        end;
        CatalogItemL."Vendor No." := VendorNoP;
        CatalogItemL.Description := Designation1G;
        CatalogItemL."Net Weight" := NetWeightG;
        CatalogItemL."Item No." := PartNumberG;
        if NetPriceIndicatorG = '1' then
            CatalogItemL."Published Cost" := UnitPurchPriceExVATG;
        CatalogItemL."Unit of Measure" := UnitOfMeasure;
        CatalogItemL."Unit Price" := UnitSalesPriceExVATG;
        CatalogItemL."Last Date Modified" := WorkDate();
        CatalogItemL.Modify();

        AddCatItemData2L.Reset();
        AddCatItemData2L.SetRange("Item No.", PartNumberG);
        AddCatItemData2L.SetRange("Manufacturer Code", ManufacturerP);
        if not AddCatItemData2L.FindFirst() then begin
            AddCatItemDataL.Init();
            AddCatItemDataL."Entry No." := CatalogItemL."Entry No.";
            AddCatItemDataL."Item No." := PartNumberG;
            AddCatItemDataL."Manufacturer Code" := ManufacturerP;
            AddCatItemDataL.Insert();
        end;
        AddCatItemDataL."Vendor Item No." := PartNumberG;
        AddCatItemDataL.Description := Designation1G;
        AddCatItemDataL."Description 2" := Designation2G;
        AddCatItemDataL."Type Code" := TypeCodeG;
        AddCatItemDataL."Tax Type" := TaxCategoryG;
        AddCatItemDataL."Net Price Indicator" := NetPriceIndicatorG;
        AddCatItemDataL."Unit Purchase Price" := UnitPurchPriceExVATG;
        AddCatItemDatal."Unit List Price" := UnitSalesPriceExVATG;
        AddCatItemDataL."Replacement Solution Code" := ReplacementCodeG;
        AddCatItemDataL."List Number" := ListNumberG;
        AddCatItemDataL."Replacement Part" := ReplacementPartG;
        AddCatItemDataL."Packaging Quantity" := PackagingQtyG;
        AddCatItemDataL."Net Weight" := NetWeightG;
        AddCatItemDataL."Item discount group Code" := ItemDiscountCode;
        AddCatItemDataL."Rebate Code" := RebateCodeG;
        AddCatItemDataL."Custom TARIC Code" := CustTARICCodeG;
        AddCatItemDataL."Index Business Line" := IndexBusiLineG;
        AddCatItemDataL.Segment := SegmentG;
        AddCatItemDataL."Slot Macrofamily" := SlotMacrofamG;
        AddCatItemDataL."Marketing family" := MarketingFamilyG;
        AddCatItemDataL.Basket := BasketG;
        AddCatItemDataL."Provision/surcharge Part No." := ProvSurchagePartG;
        AddCatItemDataL."Sales Price provison" := SellPriceOfProvisionexVATG;
        AddCatItemDataL."Standard exchange Flag" := StdExchangeFlagG;
        AddCatItemDataL."Part origin" := PartoriginG;
        AddCatItemDataL."DMS format reference" := DMSFormatReferenceG;
        AddCatItemDataL."main replacement comp. qty" := MainReplCompQtyG;
        AddCatItemDataL."Repl. Component 2 No." := ReplCompNo2G;
        AddCatItemDataL."Repl. Component 2 Qty." := ReplCompQty2G;
        AddCatItemDataL."Repl. Component 3 No." := ReplCompNo3G;
        AddCatItemDataL."Repl. Component 3 Qty." := ReplCompQty3G;
        AddCatItemDataL."Repl. Component 4 No." := ReplCompNo4G;
        AddCatItemDataL."Repl. Component 4 Qty." := ReplCompQty4G;
        AddCatItemDataL."Repl. Component 5 No." := ReplCompNo5G;
        AddCatItemDataL."Repl. Component 5 Qty." := ReplCompQty5G;
        AddCatItemDataL."Repl. Component 6 No." := ReplCompNo6G;
        AddCatItemDataL."Repl. Component 6 Qty." := ReplCompQty6G;
        AddCatItemDataL."Part Sales Management" := MarketingFamilyG;
        AddCatItemDataL."Material mod. category" := MatModificationCatG;
        AddCatItemDataL."Description 3" := Designation3G;
        AddCatItemDataL."Description 4" := Designation4G;
        AddCatItemDataL."Procurement family" := ProcurementFamG;
        AddCatItemDataL.GTIN := GTING;
        AddCatItemDataL."IAM discount Code" := IAMDiscCodeG;
        AddCatItemDataL."Hazardous goods flag" := HazardousGoodsFlagG;
        AddCatItemDataL."IAM indicator" := IAMIndicatorG;
        AddCatItemDataL."Sell by date indicator" := SellbyDateIndG;
        AddCatItemDataL."Storage duration" := StorageDurationG;
        AddCatItemDataL.CTU := CTUG;
        AddCatItemDataL."Tyre family" := TyreFamilyG;
        AddCatItemDataL."Tyre Dimensions" := TyreDimensionsG;
        AddCatItemDataL."Tyre trade name" := TyreTradeNameG;
        AddCatItemDataL.Length := LengthG;
        AddCatItemDataL."Material width" := MaterialWidthG;
        AddCatItemDataL.Height := HeightG;
        AddCatItemDataL.Volume := VolumeG;
        AddCatItemDataL."Identifier characteristic" := IdentCharacteristicG;
        AddCatItemDataL."Long description of parts" := LongDescG;
        AddCatItemDataL."Fuel efficiency" := FuelEffG;
        AddCatItemDataL."Road holding quality wet" := RoadQualityOnWetRoad;
        AddCatItemDataL."External driving noise" := ExtDrivingNoiseG;
        AddCatItemDataL."Sound wave class" := SoundWaveClassG;
        AddCatItemDataL.Modify();

        CatalogItemPrices();
        if (ReplacementCodeG > '') then begin
            InsertCatalogTempReplacements(CatalogItemL);
        end;

        if (ProvSurchagePartG > '') then begin
            InsertProvSurchItem(CatalogItemL);
        end;
    end;

    local procedure CatalogItemPrices()
    var
        CatalogItemMasterPriceL: Record "Catalog Item Master Prices";
    begin
        if NetPriceIndicatorG = '1' then begin
            if not CatalogItemMasterPriceL.Get(PartNumberG, ManufacturerG.Code, ManufacturerG."Price Category net price", AppDateG) then begin
                CatalogItemMasterPriceL.Init();
                CatalogItemMasterPriceL."Item No." := PartNumberG;
                CatalogItemMasterPriceL."Manufacturer Code" := ManufacturerG.Code;
                CatalogItemMasterPriceL."Price Category" := ManufacturerG."Price Category net price";
                CatalogItemMasterPriceL.Price := UnitPurchPriceExVATG;
                CatalogItemMasterPriceL."valid from" := AppDateG;
                CatalogItemMasterPriceL.Insert();
            end;
        end;
        if not CatalogItemMasterPriceL.Get(PartNumberG, ManufacturerG.Code, ManufacturerG."Price Category Default", AppDateG) then begin
            CatalogItemMasterPriceL.Init();
            CatalogItemMasterPriceL."Item No." := PartNumberG;
            CatalogItemMasterPriceL."Manufacturer Code" := ManufacturerG.Code;
            CatalogItemMasterPriceL."Price Category" := ManufacturerG."Price Category Default";
            CatalogItemMasterPriceL.Price := UnitSalesPriceExVATG;
            CatalogItemMasterPriceL."valid from" := AppDateG;
            CatalogItemMasterPriceL.Insert();
        end;
    end;

    local procedure InsertCatalogTempReplacements(CatalogItemP: Record "Nonstock Item")
    var
        CatalogReplTempL: Record "Catalog Item Replacements";
        CatalogReplTemp2L: Record "Catalog Item Replacements";
        ReplSolutionsL: Enum "Replacement Solutions";
    begin
        if (ReplacementCodeG = '1') then begin
            if not CatalogReplTemp2L.Get(CatalogItemP."Entry No.", CatalogItemP."Item No.", AppDateG, ReplSolutionsL::"simple replacement", ReplacementPartG) then begin
                CatalogReplTempL.Init();
                CatalogReplTempL."Entry No." := CatalogItemP."Entry No.";
                CatalogReplTempL."Item No." := CatalogItemP."Item No.";
                CatalogReplTempL."Application Date" := AppDateG;
                CatalogReplTempL."Replacement Type" := ReplSolutionsL::"simple replacement";
                CatalogReplTempL."Replacement Part" := ReplacementPartG;
                CatalogReplTempL.Description := Designation1G;
                CatalogReplTempL."Long Description" := LongDescG;
                CatalogReplTempL.Quantity := MainReplCompQtyG;
                CatalogReplTempL.Insert();
            end;
        end;

        if (ReplacementCodeG = '2') then begin
            if not CatalogReplTemp2L.Get(CatalogItemP."Entry No.", CatalogItemP."Item No.", AppDateG, ReplSolutionsL::"multiple replacement", ReplacementPartG) then begin
                CatalogReplTempL.Init();
                CatalogReplTempL."Entry No." := CatalogItemP."Entry No.";
                CatalogReplTempL."Item No." := CatalogItemP."Item No.";
                CatalogReplTempL."Application Date" := AppDateG;
                CatalogReplTempL."Replacement Type" := ReplSolutionsL::"multiple replacement";
                CatalogReplTempL."Replacement Part" := ReplacementPartG;
                CatalogReplTempL.Description := Designation1G;
                CatalogReplTempL."Long Description" := LongDescG;
                CatalogReplTempL.Quantity := MainReplCompQtyG;
                CatalogReplTempL.Insert();

                if (ReplCompNo2G > '') then begin
                    if not CatalogReplTemp2L.Get(CatalogItemP."Entry No.", CatalogItemP."Item No.", AppDateG, ReplSolutionsL::"multiple replacement", ReplCompNo2G) then begin
                        CatalogReplTempL.Init();
                        CatalogReplTempL."Entry No." := CatalogItemP."Entry No.";
                        CatalogReplTempL."Item No." := CatalogItemP."Item No.";
                        CatalogReplTempL."Application Date" := AppDateG;
                        CatalogReplTempL."Replacement Type" := ReplSolutionsL::"multiple replacement";
                        CatalogReplTempL."Replacement Part" := ReplCompNo2G;
                        CatalogReplTempL.Description := Designation1G;
                        CatalogReplTempL."Long Description" := LongDescG;
                        CatalogReplTempL.Quantity := ReplCompQty2G;
                        CatalogReplTempL.Insert();
                    end;
                end;

                if (ReplCompNo3G > '') then begin
                    if not CatalogReplTemp2L.Get(CatalogItemP."Entry No.", CatalogItemP."Item No.", AppDateG, ReplSolutionsL::"multiple replacement", ReplCompNo3G) then begin
                        CatalogReplTempL.Init();
                        CatalogReplTempL."Entry No." := CatalogItemP."Entry No.";
                        CatalogReplTempL."Item No." := CatalogItemP."Item No.";
                        CatalogReplTempL."Application Date" := AppDateG;
                        CatalogReplTempL."Replacement Type" := ReplSolutionsL::"multiple replacement";
                        CatalogReplTempL."Replacement Part" := ReplCompNo3G;
                        CatalogReplTempL.Description := Designation1G;
                        CatalogReplTempL."Long Description" := LongDescG;
                        CatalogReplTempL.Quantity := ReplCompQty3G;
                        CatalogReplTempL.Insert();
                    end;
                end;

                if (ReplCompNo4G > '') then begin
                    if not CatalogReplTemp2L.Get(CatalogItemP."Entry No.", CatalogItemP."Item No.", AppDateG, ReplSolutionsL::"multiple replacement", ReplCompNo4G) then begin
                        CatalogReplTempL.Init();
                        CatalogReplTempL."Entry No." := CatalogItemP."Entry No.";
                        CatalogReplTempL."Item No." := CatalogItemP."Item No.";
                        CatalogReplTempL."Application Date" := AppDateG;
                        CatalogReplTempL."Replacement Type" := ReplSolutionsL::"multiple replacement";
                        CatalogReplTempL."Replacement Part" := ReplCompNo4G;
                        CatalogReplTempL.Description := Designation1G;
                        CatalogReplTempL."Long Description" := LongDescG;
                        CatalogReplTempL.Quantity := ReplCompQty4G;
                        CatalogReplTempL.Insert();
                    end;
                end;

                if (ReplCompNo5G > '') then begin
                    if not CatalogReplTemp2L.Get(CatalogItemP."Entry No.", CatalogItemP."Item No.", AppDateG, ReplSolutionsL::"multiple replacement", ReplCompNo5G) then begin
                        CatalogReplTempL.Init();
                        CatalogReplTempL."Entry No." := CatalogItemP."Entry No.";
                        CatalogReplTempL."Item No." := CatalogItemP."Item No.";
                        CatalogReplTempL."Application Date" := AppDateG;
                        CatalogReplTempL."Replacement Type" := ReplSolutionsL::"multiple replacement";
                        CatalogReplTempL."Replacement Part" := ReplCompNo5G;
                        CatalogReplTempL.Description := Designation1G;
                        CatalogReplTempL."Long Description" := LongDescG;
                        CatalogReplTempL.Quantity := ReplCompQty5G;
                        CatalogReplTempL.Insert();
                    end;
                end;

                if (ReplCompNo6G > '') then begin
                    if not CatalogReplTemp2L.Get(CatalogItemP."Entry No.", CatalogItemP."Item No.", AppDateG, ReplSolutionsL::"multiple replacement", ReplCompNo6G) then begin
                        CatalogReplTempL.Init();
                        CatalogReplTempL."Entry No." := CatalogItemP."Entry No.";
                        CatalogReplTempL."Item No." := CatalogItemP."Item No.";
                        CatalogReplTempL."Application Date" := AppDateG;
                        CatalogReplTempL."Replacement Type" := ReplSolutionsL::"multiple replacement";
                        CatalogReplTempL."Replacement Part" := ReplCompNo6G;
                        CatalogReplTempL.Description := Designation1G;
                        CatalogReplTempL."Long Description" := LongDescG;
                        CatalogReplTempL.Quantity := ReplCompQty6G;
                        CatalogReplTempL.Insert();
                    end;
                end;

            end;

            if (ReplacementCodeG = '3') then begin
                if not CatalogReplTemp2L.Get(CatalogItemP."Entry No.", CatalogItemP."Item No.", AppDateG, ReplSolutionsL::"complex replacement", '') then begin
                    CatalogReplTempL.Init();
                    CatalogReplTempL."Entry No." := CatalogItemP."Entry No.";
                    CatalogReplTempL."Item No." := CatalogItemP."Item No.";
                    CatalogReplTempL."Application Date" := AppDateG;
                    CatalogReplTempL."Replacement Type" := ReplSolutionsL::"complex replacement";
                    CatalogReplTempL."Replacement Part" := '';
                    CatalogReplTempL.Description := Designation1G;
                    CatalogReplTempL."Long Description" := LongDescG;
                    CatalogReplTempL.Quantity := 0;
                    CatalogReplTempL."List Number" := ListNumberG;
                    CatalogReplTempL.Insert();
                end;
            end;

            if (ReplacementCodeG = '5') then begin
                if not CatalogReplTemp2L.Get(CatalogItemP."Entry No.", CatalogItemP."Item No.", AppDateG, ReplSolutionsL::"no longer supplied", '') then begin
                    CatalogReplTempL.Init();
                    CatalogReplTempL."Entry No." := CatalogItemP."Entry No.";
                    CatalogReplTempL."Item No." := CatalogItemP."Item No.";
                    CatalogReplTempL."Application Date" := AppDateG;
                    CatalogReplTempL."Replacement Type" := ReplSolutionsL::"no longer supplied";
                    CatalogReplTempL."Replacement Part" := '';
                    CatalogReplTempL.Description := Designation1G;
                    CatalogReplTempL."Long Description" := LongDescG;
                    CatalogReplTempL.Quantity := 0;
                    CatalogReplTempL.Insert();
                end;

            end;
        end;
    end;

    local procedure InsertProvSurchItem(CatalogItemP: Record "Nonstock Item")
    var
        CatalogProvRecL: Record "Catalog ProvSurchage Item";
        CatalogProvRec2L: Record "Catalog ProvSurchage Item";
    begin
        if not CatalogProvRec2L.Get(CatalogItemP."Entry No.", CatalogItemP."Item No.", AppDateG, ProvSurchagePartG) then begin
            CatalogProvRecL.Init();
            CatalogProvRecL."Entry No." := CatalogItemP."Entry No.";
            CatalogProvRecL."Item No." := CatalogItemP."Item No.";
            CatalogProvRecL."Long Description" := LongDescG;
            CatalogProvRecL."Manufacturer Code" := CatalogItemP."Manufacturer Code";
            CatalogProvRecL."Sales Price" := SellPriceOfProvisionexVATG;
            CatalogProvRecL.Insert();
        end;

    end;


    var
        RecordTextG: Text;
        DistributionTypeG: Text[3];
        DistributionDateG: Date;
        AppDateG: Date;
        SalesOrganisationG: Code[4];
        CountryG: Text[3];
        PriceListG: Text[2];
        PriceListTypeG: Text[1];
        CurrencyG: Text[5];
        PartNumberG: Code[20];
        Designation1G: Text[15];
        Designation2G: Text[15];
        BusinessSectorG: Code[1];
        TypeCodeG: Code[3];
        TaxCategoryG: Text[1];
        NetPriceIndicatorG: Text[1];
        UnitPurchPriceExVATG: Decimal;
        UnitSalesPriceExVATG: Decimal;
        ReplacementCodeG: Text[1];
        ListNumberG: Text[7];
        ReplacementPartG: Code[20];
        PackagingQtyG: Decimal;
        NetWeightG: Decimal;
        ItemDiscountCode: Code[2];
        RebateCodeG: Text[3];
        CustTARICCodeG: Text[17];
        IndexBusiLineG: Text[4];
        SegmentG: Text[4];
        SlotMacrofamG: Text[5];
        MarketingFamilyG: Text[5];
        BasketG: Code[1];
        ProvSurchagePartG: Code[20];
        SellPriceOfProvisionexVATG: Decimal;
        StdExchangeFlagG: Code[1];
        PartoriginG: Code[1];
        DMSFormatReferenceG: Code[20];
        MainReplCompQtyG: Decimal;
        ReplCompNo2G: Code[20];
        ReplCompQty2G: Decimal;
        ReplCompNo3G: Code[20];
        ReplCompQty3G: Decimal;
        ReplCompNo4G: Code[20];
        ReplCompQty4G: Decimal;
        ReplCompNo5G: Code[20];
        ReplCompQty5G: Decimal;
        ReplCompNo6G: Code[20];
        ReplCompQty6G: Decimal;
        ADVStatusG: Code[2];
        MatModificationCatG: Code[1];
        Designation3G: Text[15];
        Designation4G: Text[15];
        SellingFreqG: Text[2];
        ProcurementFamG: Text[3];
        GTING: Text[13];
        IAMDiscCodeG: Code[6];
        HazardousGoodsFlagG: Code[1];
        IAMIndicatorG: Code[1];
        SellbyDateIndG: Code[1];
        StorageDurationG: Integer;
        CTUG: Integer;
        TyreFamilyG: Text[3];
        TyreDimensionsG: Text[26];
        TyreTradeNameG: Text[31];
        LengthG: Decimal;
        MaterialWidthG: Decimal;
        HeightG: Decimal;
        VolumeG: Decimal;
        IdentCharacteristicG: Text[30];
        LongDescG: Text[30];
        FuelEffG: Text[1];
        RoadQualityOnWetRoad: Text[1];
        ExtDrivingNoiseG: Integer;
        SoundWaveClassG: Text[1];
        SpecialFuncG: Codeunit "cool.specialfunctions";
        ManufacturerG: Record Manufacturer;
       AMECC001: Label 'could not archive file', Comment = 'DEU="Die Datei konnte nicht archiviert werden"';
       AMECC002: Label 'Import Item Master:', Comment = 'DEU="Import Artikel Master"';
       AMECC003: Label 'Item No.:     #1################################\', Comment = 'DEU="Artikel Nr.:     #1################################\"';
       AMECC004: Label 'Manufacturer: #2###############', Comment = 'DEU="Hersteller:  #2###############"';
        DialogG: Dialog;

}