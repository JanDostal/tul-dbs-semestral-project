-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-02-07 10:06:32.784

-- tables
-- Table: BranchOffice
CREATE TABLE BranchOffice (
    branchOfficeId int  NOT NULL AUTO_INCREMENT,
    branchOfficeAddressStreetName nvarchar(40)  NOT NULL,
    branchOfficeAddressBuildingRegistryNumber varchar(12)  NOT NULL,
    branchOfficeName nvarchar(40)  NOT NULL,
    branchOfficeEmail nvarchar(40)  NOT NULL,
    branchOfficePhone varchar(15)  NOT NULL,
    isCancelled bit(1)  NOT NULL DEFAULT 0,
    branchOfficeAddressCityPostCode int  NOT NULL,
    UNIQUE INDEX UQ_BranchOfficeEmail (branchOfficeEmail),
    UNIQUE INDEX UQ_BranchOfficePhone (branchOfficePhone),
    UNIQUE INDEX UQ_BranchOfficeAddress (branchOfficeAddressStreetName,branchOfficeAddressBuildingRegistryNumber,branchOfficeAddressCityPostCode),
    CONSTRAINT PK_BranchOffice PRIMARY KEY (branchOfficeId)
);

-- Table: City
CREATE TABLE City (
    cityPostCode int  NOT NULL,
    `name` nvarchar(40)  NOT NULL,
    CONSTRAINT PK_City PRIMARY KEY (cityPostCode)
);

-- Table: IsicCard
CREATE TABLE IsicCard (
    isicCardNumber varchar(14)  NOT NULL,
    registeredAccountEmail nvarchar(40)  NOT NULL,
    UNIQUE INDEX UQ_RegisteredAccountEmail (registeredAccountEmail),
    CONSTRAINT PK_IsicCard PRIMARY KEY (isicCardNumber)
);

-- Table: Opuscard
CREATE TABLE Opuscard (
    opuscardNumber varchar(18)  NOT NULL,
    validityEndDate date  NOT NULL,
    isActive bit(1)  NOT NULL DEFAULT 1,
    opuscardOrderNumber int  NOT NULL,
    UNIQUE INDEX UQ_OpuscardOrderNumber (opuscardOrderNumber),
    CONSTRAINT PK_Opuscard PRIMARY KEY (opuscardNumber)
);

-- Table: OpuscardOrder
CREATE TABLE OpuscardOrder (
    opuscardOrderNumber int  NOT NULL AUTO_INCREMENT,
    personPhoto mediumblob  NOT NULL,
    opuscardDeliveryAddressStreetName nvarchar(40)  NULL,
    opuscardDeliveryAddressBuildingRegistryNumber varchar(12)  NULL,
    price decimal(13,4)  NOT NULL,
    orderCreationDate datetime  NOT NULL,
    paymentDate datetime  NULL,
    paymentTypeId int  NULL,
    opuscardOrderStateId int  NOT NULL,
    opuscardProductionBranchOfficeId int  NULL,
    opuscardPickUpBranchOfficeId int  NULL,
    opuscardDeliveryAddressCityPostCode int  NULL,
    registeredAccountEmail nvarchar(40)  NOT NULL,
    CONSTRAINT PK_OpuscardOrder PRIMARY KEY (opuscardOrderNumber)
);

-- Table: OpuscardOrderState
CREATE TABLE OpuscardOrderState (
    opuscardOrderStateId int  NOT NULL AUTO_INCREMENT,
    opuscardOrderStateName nvarchar(20)  NOT NULL,
    UNIQUE INDEX UQ_OpuscardOrderStateName (opuscardOrderStateName),
    CONSTRAINT PK_OpuscardOrderState PRIMARY KEY (opuscardOrderStateId)
);

-- Table: PaymentType
CREATE TABLE PaymentType (
    paymentTypeId int  NOT NULL AUTO_INCREMENT,
    paymentTypeName nvarchar(20)  NOT NULL,
    isAvailable bit(1)  NOT NULL DEFAULT 1,
    UNIQUE INDEX UQ_PaymentTypeName (paymentTypeName),
    CONSTRAINT PK_PaymentType PRIMARY KEY (paymentTypeId)
);

-- Table: RegisteredAccount
CREATE TABLE RegisteredAccount (
    registeredAccountEmail nvarchar(40)  NOT NULL,
    forename nvarchar(25)  NOT NULL,
    surname nvarchar(25)  NOT NULL,
    middleName nvarchar(25)  NULL,
    birthDate date  NOT NULL,
    registeredAccountPhone varchar(15)  NULL,
    registeredAccountPassword varchar(80)  NOT NULL,
    accountName nvarchar(20)  NOT NULL,
    isEmailConfirmed bit(1)  NOT NULL DEFAULT 0,
    isPhoneConfirmed bit(1)  NOT NULL DEFAULT 0,
    registeredAccountValidityCode int  NOT NULL,
    UNIQUE INDEX UQ_RegisteredAccountValidityCode (registeredAccountValidityCode),
    UNIQUE INDEX UQ_RegisteredAccountPassword (registeredAccountPassword),
    CONSTRAINT PK_RegisteredAccount PRIMARY KEY (registeredAccountEmail)
);

-- Table: RegisteredAccountSharedWith
CREATE TABLE RegisteredAccountSharedWith (
    linkedSourceRegisteredAccountEmail nvarchar(40)  NOT NULL,
    linkedDestinationRegisteredAccountEmail nvarchar(40)  NOT NULL,
    CONSTRAINT PK_RegisteredAccountSharedWith PRIMARY KEY (linkedSourceRegisteredAccountEmail,linkedDestinationRegisteredAccountEmail)
);

-- Table: RegisteredAccountTarifCategory
CREATE TABLE RegisteredAccountTarifCategory (
    registeredAccountEmail nvarchar(40)  NOT NULL,
    tarifCategoryId int  NOT NULL,
    isTarifCategoryValid bit(1)  NOT NULL DEFAULT 0,
    CONSTRAINT PK_RegisteredAccountTarifCategory PRIMARY KEY (registeredAccountEmail,tarifCategoryId)
);

-- Table: TarifCategory
CREATE TABLE TarifCategory (
    tarifCategoryId int  NOT NULL AUTO_INCREMENT,
    tarifCategoryName nvarchar(20)  NOT NULL,
    lowerAgeBoundary int  NULL,
    upperAgeBoundary int  NULL,
    UNIQUE INDEX UQ_TarifCategoryName (tarifCategoryName),
    CONSTRAINT PK_TarifCategory PRIMARY KEY (tarifCategoryId)
);

-- Table: TarifZone
CREATE TABLE TarifZone (
    tarifZoneNumber varchar(4)  NOT NULL,
    tarifZoneName nvarchar(40)  NOT NULL,
    UNIQUE INDEX UQ_TarifZoneName (tarifZoneName),
    CONSTRAINT PK_TarifZone PRIMARY KEY (tarifZoneNumber)
);

-- Table: TarifZoneConnectedWith
CREATE TABLE TarifZoneConnectedWith (
    connectedSourceTarifZoneNumber varchar(4)  NOT NULL,
    connectedDestinationTarifZoneNumber varchar(4)  NOT NULL,
    kilometersDistance float(24,3)  NOT NULL,
    CONSTRAINT PK_TarifZoneConnectedWith PRIMARY KEY (connectedSourceTarifZoneNumber,connectedDestinationTarifZoneNumber)
);

-- Table: TimeCoupon
CREATE TABLE TimeCoupon (
    timeCouponId int  NOT NULL AUTO_INCREMENT,
    validityStartDate date  NOT NULL,
    price decimal(13,4)  NOT NULL,
    timeCouponOrderNumber int  NOT NULL,
    timeCouponTypeDaysCount int  NOT NULL,
    boardingTarifZoneNumber varchar(4)  NOT NULL,
    exitTarifZoneNumber varchar(4)  NOT NULL,
    opuscardNumber varchar(18)  NOT NULL,
    registeredAccountEmail nvarchar(40)  NOT NULL,
    tarifCategoryId int  NOT NULL,
    CONSTRAINT PK_TimeCoupon PRIMARY KEY (timeCouponId)
);

-- Table: TimeCouponOrder
CREATE TABLE TimeCouponOrder (
    timeCouponOrderNumber int  NOT NULL AUTO_INCREMENT,
    paymentDate datetime  NULL,
    orderCreationDate datetime  NOT NULL,
    timeCouponOrderStateId int  NOT NULL,
    paymentTypeId int  NULL,
    CONSTRAINT PK_TimeCouponOrder PRIMARY KEY (timeCouponOrderNumber)
);

-- Table: TimeCouponOrderState
CREATE TABLE TimeCouponOrderState (
    timeCouponOrderStateId int  NOT NULL AUTO_INCREMENT,
    timeCouponOrderStateName nvarchar(20)  NOT NULL,
    UNIQUE INDEX UQ_TimeCouponOrderStateName (timeCouponOrderStateName),
    CONSTRAINT PK_TimeCouponOrderState PRIMARY KEY (timeCouponOrderStateId)
);

-- Table: TimeCouponType
CREATE TABLE TimeCouponType (
    timeCouponTypeDaysCount int  NOT NULL,
    CONSTRAINT PK_TimeCouponType PRIMARY KEY (timeCouponTypeDaysCount)
);

-- foreign keys
-- Reference: FK_BoardingTarifZone (table: TimeCoupon)
ALTER TABLE TimeCoupon ADD CONSTRAINT FK_BoardingTarifZone FOREIGN KEY FK_BoardingTarifZone (boardingTarifZoneNumber)
    REFERENCES TarifZone (tarifZoneNumber);

-- Reference: FK_BranchOfficeAddressCity (table: BranchOffice)
ALTER TABLE BranchOffice ADD CONSTRAINT FK_BranchOfficeAddressCity FOREIGN KEY FK_BranchOfficeAddressCity (branchOfficeAddressCityPostCode)
    REFERENCES City (cityPostCode);

-- Reference: FK_ConnectedDestinationTarifZone (table: TarifZoneConnectedWith)
ALTER TABLE TarifZoneConnectedWith ADD CONSTRAINT FK_ConnectedDestinationTarifZone FOREIGN KEY FK_ConnectedDestinationTarifZone (connectedDestinationTarifZoneNumber)
    REFERENCES TarifZone (tarifZoneNumber);

-- Reference: FK_ConnectedSourceTarifZone (table: TarifZoneConnectedWith)
ALTER TABLE TarifZoneConnectedWith ADD CONSTRAINT FK_ConnectedSourceTarifZone FOREIGN KEY FK_ConnectedSourceTarifZone (connectedSourceTarifZoneNumber)
    REFERENCES TarifZone (tarifZoneNumber);

-- Reference: FK_ExitTarifZone (table: TimeCoupon)
ALTER TABLE TimeCoupon ADD CONSTRAINT FK_ExitTarifZone FOREIGN KEY FK_ExitTarifZone (exitTarifZoneNumber)
    REFERENCES TarifZone (tarifZoneNumber);

-- Reference: FK_LinkedDestinationRegisteredAccount (table: RegisteredAccountSharedWith)
ALTER TABLE RegisteredAccountSharedWith ADD CONSTRAINT FK_LinkedDestinationRegisteredAccount FOREIGN KEY FK_LinkedDestinationRegisteredAccount (linkedDestinationRegisteredAccountEmail)
    REFERENCES RegisteredAccount (registeredAccountEmail);

-- Reference: FK_LinkedSourceRegisteredAccount (table: RegisteredAccountSharedWith)
ALTER TABLE RegisteredAccountSharedWith ADD CONSTRAINT FK_LinkedSourceRegisteredAccount FOREIGN KEY FK_LinkedSourceRegisteredAccount (linkedSourceRegisteredAccountEmail)
    REFERENCES RegisteredAccount (registeredAccountEmail);

-- Reference: FK_Opuscard (table: TimeCoupon)
ALTER TABLE TimeCoupon ADD CONSTRAINT FK_Opuscard FOREIGN KEY FK_Opuscard (opuscardNumber)
    REFERENCES Opuscard (opuscardNumber);

-- Reference: FK_OpuscardDeliveryAddressCity (table: OpuscardOrder)
ALTER TABLE OpuscardOrder ADD CONSTRAINT FK_OpuscardDeliveryAddressCity FOREIGN KEY FK_OpuscardDeliveryAddressCity (opuscardDeliveryAddressCityPostCode)
    REFERENCES City (cityPostCode);

-- Reference: FK_OpuscardOrder (table: Opuscard)
ALTER TABLE Opuscard ADD CONSTRAINT FK_OpuscardOrder FOREIGN KEY FK_OpuscardOrder (opuscardOrderNumber)
    REFERENCES OpuscardOrder (opuscardOrderNumber);

-- Reference: FK_OpuscardOrderState (table: OpuscardOrder)
ALTER TABLE OpuscardOrder ADD CONSTRAINT FK_OpuscardOrderState FOREIGN KEY FK_OpuscardOrderState (opuscardOrderStateId)
    REFERENCES OpuscardOrderState (opuscardOrderStateId);

-- Reference: FK_OpuscardPickUpBranchOffice (table: OpuscardOrder)
ALTER TABLE OpuscardOrder ADD CONSTRAINT FK_OpuscardPickUpBranchOffice FOREIGN KEY FK_OpuscardPickUpBranchOffice (opuscardPickUpBranchOfficeId)
    REFERENCES BranchOffice (branchOfficeId);

-- Reference: FK_OpuscardProductionBranchOffice (table: OpuscardOrder)
ALTER TABLE OpuscardOrder ADD CONSTRAINT FK_OpuscardProductionBranchOffice FOREIGN KEY FK_OpuscardProductionBranchOffice (opuscardProductionBranchOfficeId)
    REFERENCES BranchOffice (branchOfficeId);

-- Reference: FK_PaymentTypeForOpuscardOrder (table: OpuscardOrder)
ALTER TABLE OpuscardOrder ADD CONSTRAINT FK_PaymentTypeForOpuscardOrder FOREIGN KEY FK_PaymentTypeForOpuscardOrder (paymentTypeId)
    REFERENCES PaymentType (paymentTypeId);

-- Reference: FK_PaymentTypeForTimeCouponOrder (table: TimeCouponOrder)
ALTER TABLE TimeCouponOrder ADD CONSTRAINT FK_PaymentTypeForTimeCouponOrder FOREIGN KEY FK_PaymentTypeForTimeCouponOrder (paymentTypeId)
    REFERENCES PaymentType (paymentTypeId);

-- Reference: FK_RegisteredAccountForIsicCard (table: IsicCard)
ALTER TABLE IsicCard ADD CONSTRAINT FK_RegisteredAccountForIsicCard FOREIGN KEY FK_RegisteredAccountForIsicCard (registeredAccountEmail)
    REFERENCES RegisteredAccount (registeredAccountEmail)
    ON DELETE CASCADE;

-- Reference: FK_RegisteredAccountForOpuscardOrder (table: OpuscardOrder)
ALTER TABLE OpuscardOrder ADD CONSTRAINT FK_RegisteredAccountForOpuscardOrder FOREIGN KEY FK_RegisteredAccountForOpuscardOrder (registeredAccountEmail)
    REFERENCES RegisteredAccount (registeredAccountEmail);

-- Reference: FK_RegisteredAccountForTarifCategory (table: RegisteredAccountTarifCategory)
ALTER TABLE RegisteredAccountTarifCategory ADD CONSTRAINT FK_RegisteredAccountForTarifCategory FOREIGN KEY FK_RegisteredAccountForTarifCategory (registeredAccountEmail)
    REFERENCES RegisteredAccount (registeredAccountEmail)
    ON DELETE CASCADE;

-- Reference: FK_RegisteredAccountTarifCategory (table: TimeCoupon)
ALTER TABLE TimeCoupon ADD CONSTRAINT FK_RegisteredAccountTarifCategory FOREIGN KEY FK_RegisteredAccountTarifCategory (registeredAccountEmail,tarifCategoryId)
    REFERENCES RegisteredAccountTarifCategory (registeredAccountEmail,tarifCategoryId);

-- Reference: FK_TarifCategory (table: RegisteredAccountTarifCategory)
ALTER TABLE RegisteredAccountTarifCategory ADD CONSTRAINT FK_TarifCategory FOREIGN KEY FK_TarifCategory (tarifCategoryId)
    REFERENCES TarifCategory (tarifCategoryId);

-- Reference: FK_TimeCouponOrder (table: TimeCoupon)
ALTER TABLE TimeCoupon ADD CONSTRAINT FK_TimeCouponOrder FOREIGN KEY FK_TimeCouponOrder (timeCouponOrderNumber)
    REFERENCES TimeCouponOrder (timeCouponOrderNumber);

-- Reference: FK_TimeCouponOrderState (table: TimeCouponOrder)
ALTER TABLE TimeCouponOrder ADD CONSTRAINT FK_TimeCouponOrderState FOREIGN KEY FK_TimeCouponOrderState (timeCouponOrderStateId)
    REFERENCES TimeCouponOrderState (timeCouponOrderStateId);

-- Reference: FK_TimeCouponType (table: TimeCoupon)
ALTER TABLE TimeCoupon ADD CONSTRAINT FK_TimeCouponType FOREIGN KEY FK_TimeCouponType (timeCouponTypeDaysCount)
    REFERENCES TimeCouponType (timeCouponTypeDaysCount);

-- End of file.

