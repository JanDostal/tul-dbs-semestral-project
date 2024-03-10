-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-02-07 13:53:43.615

-- tables
-- Table: BranchOffice
CREATE TABLE BranchOffice (
    branchOfficeId int  NOT NULL IDENTITY,
    branchOfficeAddressStreetName nvarchar(40)  NOT NULL,
    branchOfficeAddressBuildingRegistryNumber varchar(12)  NOT NULL,
    branchOfficeName nvarchar(40)  NOT NULL,
    branchOfficeEmail nvarchar(40)  NOT NULL,
    branchOfficePhone varchar(15)  NOT NULL,
    isCancelled bit  NOT NULL DEFAULT 0,
    branchOfficeAddressCityPostCode int  NOT NULL,
    CONSTRAINT UQ_BranchOfficeEmail UNIQUE (branchOfficeEmail),
    CONSTRAINT UQ_BranchOfficePhone UNIQUE (branchOfficePhone),
    CONSTRAINT UQ_BranchOfficeAddress UNIQUE (branchOfficeAddressStreetName, branchOfficeAddressBuildingRegistryNumber, branchOfficeAddressCityPostCode),
    CONSTRAINT PK_BranchOffice PRIMARY KEY  (branchOfficeId)
);

-- Table: City
CREATE TABLE City (
    cityPostCode int  NOT NULL,
    [name] nvarchar(40)  NOT NULL,
    CONSTRAINT PK_City PRIMARY KEY  (cityPostCode)
);

-- Table: IsicCard
CREATE TABLE IsicCard (
    isicCardNumber varchar(14)  NOT NULL,
    registeredAccountEmail nvarchar(40)  NOT NULL,
    CONSTRAINT UQ_RegisteredAccountEmail UNIQUE (registeredAccountEmail),
    CONSTRAINT PK_IsicCard PRIMARY KEY  (isicCardNumber)
);

-- Table: Opuscard
CREATE TABLE Opuscard (
    opuscardNumber varchar(18)  NOT NULL,
    validityEndDate date  NOT NULL,
    isActive bit  NOT NULL DEFAULT 1,
    opuscardOrderNumber int  NOT NULL,
    CONSTRAINT UQ_OpuscardOrderNumber UNIQUE (opuscardOrderNumber),
    CONSTRAINT PK_Opuscard PRIMARY KEY  (opuscardNumber)
);

-- Table: OpuscardOrder
CREATE TABLE OpuscardOrder (
    opuscardOrderNumber int  NOT NULL IDENTITY,
    personPhoto varbinary(max)  NOT NULL,
    opuscardDeliveryAddressStreetName nvarchar(40)  NULL,
    opuscardDeliveryAddressBuildingRegistryNumber varchar(12)  NULL,
    price money  NOT NULL,
    orderCreationDate datetime  NOT NULL,
    paymentDate datetime  NULL,
    paymentTypeId int  NULL,
    opuscardOrderStateId int  NOT NULL,
    opuscardProductionBranchOfficeId int  NULL,
    opuscardPickUpBranchOfficeId int  NULL,
    opuscardDeliveryAddressCityPostCode int  NULL,
    registeredAccountEmail nvarchar(40)  NOT NULL,
    CONSTRAINT PK_OpuscardOrder PRIMARY KEY  (opuscardOrderNumber)
);

-- Table: OpuscardOrderState
CREATE TABLE OpuscardOrderState (
    opuscardOrderStateId int  NOT NULL IDENTITY,
    opuscardOrderStateName nvarchar(20)  NOT NULL,
    CONSTRAINT UQ_OpuscardOrderStateName UNIQUE (opuscardOrderStateName),
    CONSTRAINT PK_OpuscardOrderState PRIMARY KEY  (opuscardOrderStateId)
);

-- Table: PaymentType
CREATE TABLE PaymentType (
    paymentTypeId int  NOT NULL IDENTITY,
    paymentTypeName nvarchar(20)  NOT NULL,
    isAvailable bit  NOT NULL DEFAULT 1,
    CONSTRAINT UQ_PaymentTypeName UNIQUE (paymentTypeName),
    CONSTRAINT PK_PaymentType PRIMARY KEY  (paymentTypeId)
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
    isEmailConfirmed bit  NOT NULL DEFAULT 0,
    isPhoneConfirmed bit  NOT NULL DEFAULT 0,
    registeredAccountValidityCode int  NOT NULL,
    CONSTRAINT UQ_RegisteredAccountValidityCode UNIQUE (registeredAccountValidityCode),
    CONSTRAINT UQ_RegisteredAccountPassword UNIQUE (registeredAccountPassword),
    CONSTRAINT PK_RegisteredAccount PRIMARY KEY  (registeredAccountEmail)
);

-- Table: RegisteredAccountSharedWith
CREATE TABLE RegisteredAccountSharedWith (
    linkedSourceRegisteredAccountEmail nvarchar(40)  NOT NULL,
    linkedDestinationRegisteredAccountEmail nvarchar(40)  NOT NULL,
    CONSTRAINT PK_RegisteredAccountSharedWith PRIMARY KEY  (linkedSourceRegisteredAccountEmail,linkedDestinationRegisteredAccountEmail)
);

-- Table: RegisteredAccountTarifCategory
CREATE TABLE RegisteredAccountTarifCategory (
    registeredAccountEmail nvarchar(40)  NOT NULL,
    tarifCategoryId int  NOT NULL,
    isTarifCategoryValid bit  NOT NULL DEFAULT 0,
    CONSTRAINT PK_RegisteredAccountTarifCategory PRIMARY KEY  (registeredAccountEmail,tarifCategoryId)
);

-- Table: TarifCategory
CREATE TABLE TarifCategory (
    tarifCategoryId int  NOT NULL IDENTITY,
    tarifCategoryName nvarchar(20)  NOT NULL,
    lowerAgeBoundary int  NULL,
    upperAgeBoundary int  NULL,
    CONSTRAINT UQ_TarifCategoryName UNIQUE (tarifCategoryName),
    CONSTRAINT PK_TarifCategory PRIMARY KEY  (tarifCategoryId)
);

-- Table: TarifZone
CREATE TABLE TarifZone (
    tarifZoneNumber varchar(4)  NOT NULL,
    tarifZoneName nvarchar(40)  NOT NULL,
    CONSTRAINT UQ_TarifZoneName UNIQUE (tarifZoneName),
    CONSTRAINT PK_TarifZone PRIMARY KEY  (tarifZoneNumber)
);

-- Table: TarifZoneConnectedWith
CREATE TABLE TarifZoneConnectedWith (
    connectedSourceTarifZoneNumber varchar(4)  NOT NULL,
    connectedDestinationTarifZoneNumber varchar(4)  NOT NULL,
    kilometersDistance float(24)  NOT NULL,
    CONSTRAINT PK_TarifZoneConnectedWith PRIMARY KEY  (connectedSourceTarifZoneNumber,connectedDestinationTarifZoneNumber)
);

-- Table: TimeCoupon
CREATE TABLE TimeCoupon (
    timeCouponId int  NOT NULL IDENTITY,
    validityStartDate date  NOT NULL,
    price money  NOT NULL,
    timeCouponOrderNumber int  NOT NULL,
    timeCouponTypeDaysCount int  NOT NULL,
    boardingTarifZoneNumber varchar(4)  NOT NULL,
    exitTarifZoneNumber varchar(4)  NOT NULL,
    opuscardNumber varchar(18)  NOT NULL,
    registeredAccountEmail nvarchar(40)  NOT NULL,
    tarifCategoryId int  NOT NULL,
    CONSTRAINT PK_TimeCoupon PRIMARY KEY  (timeCouponId)
);

-- Table: TimeCouponOrder
CREATE TABLE TimeCouponOrder (
    timeCouponOrderNumber int  NOT NULL IDENTITY,
    paymentDate datetime  NULL,
    orderCreationDate datetime  NOT NULL,
    timeCouponOrderStateId int  NOT NULL,
    paymentTypeId int  NULL,
    CONSTRAINT PK_TimeCouponOrder PRIMARY KEY  (timeCouponOrderNumber)
);

-- Table: TimeCouponOrderState
CREATE TABLE TimeCouponOrderState (
    timeCouponOrderStateId int  NOT NULL IDENTITY,
    timeCouponOrderStateName nvarchar(20)  NOT NULL,
    CONSTRAINT UQ_TimeCouponOrderStateName UNIQUE (timeCouponOrderStateName),
    CONSTRAINT PK_TimeCouponOrderState PRIMARY KEY  (timeCouponOrderStateId)
);

-- Table: TimeCouponType
CREATE TABLE TimeCouponType (
    timeCouponTypeDaysCount int  NOT NULL,
    CONSTRAINT PK_TimeCouponType PRIMARY KEY  (timeCouponTypeDaysCount)
);

-- foreign keys
-- Reference: FK_BoardingTarifZone (table: TimeCoupon)
ALTER TABLE TimeCoupon ADD CONSTRAINT FK_BoardingTarifZone
    FOREIGN KEY (boardingTarifZoneNumber)
    REFERENCES TarifZone (tarifZoneNumber);

-- Reference: FK_BranchOfficeAddressCity (table: BranchOffice)
ALTER TABLE BranchOffice ADD CONSTRAINT FK_BranchOfficeAddressCity
    FOREIGN KEY (branchOfficeAddressCityPostCode)
    REFERENCES City (cityPostCode);

-- Reference: FK_ConnectedDestinationTarifZone (table: TarifZoneConnectedWith)
ALTER TABLE TarifZoneConnectedWith ADD CONSTRAINT FK_ConnectedDestinationTarifZone
    FOREIGN KEY (connectedDestinationTarifZoneNumber)
    REFERENCES TarifZone (tarifZoneNumber);

-- Reference: FK_ConnectedSourceTarifZone (table: TarifZoneConnectedWith)
ALTER TABLE TarifZoneConnectedWith ADD CONSTRAINT FK_ConnectedSourceTarifZone
    FOREIGN KEY (connectedSourceTarifZoneNumber)
    REFERENCES TarifZone (tarifZoneNumber);

-- Reference: FK_ExitTarifZone (table: TimeCoupon)
ALTER TABLE TimeCoupon ADD CONSTRAINT FK_ExitTarifZone
    FOREIGN KEY (exitTarifZoneNumber)
    REFERENCES TarifZone (tarifZoneNumber);

-- Reference: FK_LinkedDestinationRegisteredAccount (table: RegisteredAccountSharedWith)
ALTER TABLE RegisteredAccountSharedWith ADD CONSTRAINT FK_LinkedDestinationRegisteredAccount
    FOREIGN KEY (linkedDestinationRegisteredAccountEmail)
    REFERENCES RegisteredAccount (registeredAccountEmail);

-- Reference: FK_LinkedSourceRegisteredAccount (table: RegisteredAccountSharedWith)
ALTER TABLE RegisteredAccountSharedWith ADD CONSTRAINT FK_LinkedSourceRegisteredAccount
    FOREIGN KEY (linkedSourceRegisteredAccountEmail)
    REFERENCES RegisteredAccount (registeredAccountEmail);

-- Reference: FK_Opuscard (table: TimeCoupon)
ALTER TABLE TimeCoupon ADD CONSTRAINT FK_Opuscard
    FOREIGN KEY (opuscardNumber)
    REFERENCES Opuscard (opuscardNumber);

-- Reference: FK_OpuscardDeliveryAddressCity (table: OpuscardOrder)
ALTER TABLE OpuscardOrder ADD CONSTRAINT FK_OpuscardDeliveryAddressCity
    FOREIGN KEY (opuscardDeliveryAddressCityPostCode)
    REFERENCES City (cityPostCode);

-- Reference: FK_OpuscardOrder (table: Opuscard)
ALTER TABLE Opuscard ADD CONSTRAINT FK_OpuscardOrder
    FOREIGN KEY (opuscardOrderNumber)
    REFERENCES OpuscardOrder (opuscardOrderNumber);

-- Reference: FK_OpuscardOrderState (table: OpuscardOrder)
ALTER TABLE OpuscardOrder ADD CONSTRAINT FK_OpuscardOrderState
    FOREIGN KEY (opuscardOrderStateId)
    REFERENCES OpuscardOrderState (opuscardOrderStateId);

-- Reference: FK_OpuscardPickUpBranchOffice (table: OpuscardOrder)
ALTER TABLE OpuscardOrder ADD CONSTRAINT FK_OpuscardPickUpBranchOffice
    FOREIGN KEY (opuscardPickUpBranchOfficeId)
    REFERENCES BranchOffice (branchOfficeId);

-- Reference: FK_OpuscardProductionBranchOffice (table: OpuscardOrder)
ALTER TABLE OpuscardOrder ADD CONSTRAINT FK_OpuscardProductionBranchOffice
    FOREIGN KEY (opuscardProductionBranchOfficeId)
    REFERENCES BranchOffice (branchOfficeId);

-- Reference: FK_PaymentTypeForOpuscardOrder (table: OpuscardOrder)
ALTER TABLE OpuscardOrder ADD CONSTRAINT FK_PaymentTypeForOpuscardOrder
    FOREIGN KEY (paymentTypeId)
    REFERENCES PaymentType (paymentTypeId);

-- Reference: FK_PaymentTypeForTimeCouponOrder (table: TimeCouponOrder)
ALTER TABLE TimeCouponOrder ADD CONSTRAINT FK_PaymentTypeForTimeCouponOrder
    FOREIGN KEY (paymentTypeId)
    REFERENCES PaymentType (paymentTypeId);

-- Reference: FK_RegisteredAccountForIsicCard (table: IsicCard)
ALTER TABLE IsicCard ADD CONSTRAINT FK_RegisteredAccountForIsicCard
    FOREIGN KEY (registeredAccountEmail)
    REFERENCES RegisteredAccount (registeredAccountEmail)
    ON DELETE  CASCADE;

-- Reference: FK_RegisteredAccountForOpuscardOrder (table: OpuscardOrder)
ALTER TABLE OpuscardOrder ADD CONSTRAINT FK_RegisteredAccountForOpuscardOrder
    FOREIGN KEY (registeredAccountEmail)
    REFERENCES RegisteredAccount (registeredAccountEmail);

-- Reference: FK_RegisteredAccountForTarifCategory (table: RegisteredAccountTarifCategory)
ALTER TABLE RegisteredAccountTarifCategory ADD CONSTRAINT FK_RegisteredAccountForTarifCategory
    FOREIGN KEY (registeredAccountEmail)
    REFERENCES RegisteredAccount (registeredAccountEmail)
    ON DELETE  CASCADE;

-- Reference: FK_RegisteredAccountTarifCategory (table: TimeCoupon)
ALTER TABLE TimeCoupon ADD CONSTRAINT FK_RegisteredAccountTarifCategory
    FOREIGN KEY (registeredAccountEmail,tarifCategoryId)
    REFERENCES RegisteredAccountTarifCategory (registeredAccountEmail,tarifCategoryId);

-- Reference: FK_TarifCategory (table: RegisteredAccountTarifCategory)
ALTER TABLE RegisteredAccountTarifCategory ADD CONSTRAINT FK_TarifCategory
    FOREIGN KEY (tarifCategoryId)
    REFERENCES TarifCategory (tarifCategoryId);

-- Reference: FK_TimeCouponOrder (table: TimeCoupon)
ALTER TABLE TimeCoupon ADD CONSTRAINT FK_TimeCouponOrder
    FOREIGN KEY (timeCouponOrderNumber)
    REFERENCES TimeCouponOrder (timeCouponOrderNumber);

-- Reference: FK_TimeCouponOrderState (table: TimeCouponOrder)
ALTER TABLE TimeCouponOrder ADD CONSTRAINT FK_TimeCouponOrderState
    FOREIGN KEY (timeCouponOrderStateId)
    REFERENCES TimeCouponOrderState (timeCouponOrderStateId);

-- Reference: FK_TimeCouponType (table: TimeCoupon)
ALTER TABLE TimeCoupon ADD CONSTRAINT FK_TimeCouponType
    FOREIGN KEY (timeCouponTypeDaysCount)
    REFERENCES TimeCouponType (timeCouponTypeDaysCount);

-- End of file.

