-- 1. Vypište všechna kontaktní místa IDOL, která vyrobila alespoň jednu opuscard kartu. Každou pobočku vypište ve formátu: NazevPobocky, NazevMesta, NazevUlice, CisloPopisne. Součástí výpisu můžou být i zrušené pobočky.

SELECT DISTINCT
	BranchOffice.branchOfficeName AS NazevPobocky,
	City.[name] AS NazevMesta,
	BranchOffice.branchOfficeAddressStreetName AS NazevUlice,
	BranchOffice.branchOfficeAddressBuildingRegistryNumber AS CisloPopisne
FROM BranchOffice
INNER JOIN OpuscardOrder ON 
	(BranchOffice.branchOfficeId = OpuscardOrder.opuscardProductionBranchOfficeId)
INNER JOIN City ON
	(City.cityPostCode = BranchOffice.branchOfficeAddressCityPostCode);

-- 2. Vypište všechny časové kupóny, které byly úspěšně zaplaceny a zároveň zakoupeny v letech 2019 a výše. Pro každý kupón vypište ve formátu: CisloOpuscard, EmailMajiteleOpuscard, IdKuponu, DatumCasZaplaceniKuponu, CenaKuponu, CisloObjednavky.

SELECT 
	Opuscard.opuscardNumber AS CisloOpuscard,
	TimeCoupon.registeredAccountEmail AS EmailMajiteleOpuscard,
	TimeCoupon.timeCouponId AS IdKuponu,
	TimeCouponOrder.paymentDate AS DatumCasZaplaceniKuponu,
	TimeCoupon.price AS CenaKuponu,
	TimeCouponOrder.timeCouponOrderNumber AS CisloObjednavky
FROM TimeCoupon
INNER JOIN TimeCouponOrder ON 
(
	TimeCouponOrder.timeCouponOrderNumber = TimeCoupon.timeCouponOrderNumber AND
	TimeCouponOrder.paymentDate IS NOT NULL AND
	TimeCouponOrder.paymentDate >= '2019-01-01 00:00:00'
)
INNER JOIN Opuscard ON
	(Opuscard.opuscardNumber = TimeCoupon.opuscardNumber);

-- 3. Vypište všechny uživatele s potvrzeným emailem a zároveň potvrzeným mobilem, pokud ho mají, kteří mají vybranou ověřenou tarifní kategorii obsahující "ZTP" nebo ověřenou kategorii obsahující "Důchodce" a zároveň s někým sdíleli alespoň jednou svůj účet. Pro každého uživatele vypište ve formátu: EmailUzivatele, Jmeno, Prijmeni.

SELECT DISTINCT
	RegisteredAccount.registeredAccountEmail AS EmailUzivatele,
	RegisteredAccount.forename AS Jmeno,
	RegisteredAccount.surname AS Prijmeni
FROM RegisteredAccountTarifCategory
INNER JOIN TarifCategory ON 
(
	TarifCategory.tarifCategoryId = RegisteredAccountTarifCategory.tarifCategoryId AND
	(TarifCategory.tarifCategoryName LIKE '%ZTP%' OR TarifCategory.tarifCategoryName LIKE '%Důchodce%') AND
	RegisteredAccountTarifCategory.isTarifCategoryValid = 1
)
INNER JOIN RegisteredAccount ON
(
	RegisteredAccount.registeredAccountEmail = RegisteredAccountTarifCategory.registeredAccountEmail AND
	RegisteredAccount.isEmailConfirmed = 1 AND
	(RegisteredAccount.registeredAccountPhone IS NULL OR RegisteredAccount.isPhoneConfirmed = 1)
)
INNER JOIN RegisteredAccountSharedWith ON
	(RegisteredAccount.registeredAccountEmail = RegisteredAccountSharedWith.linkedSourceRegisteredAccountEmail);

-- 4. Vypište všechna města, ve kterých si uživatelé veřejné dopravy alespoň jednou reálně vyzvedli (stav objednávky: "Karta obdržena") opuscard kartu na pobočce. Zahrňte i zrušené pobočky. Vypište ve formátu: NazevMesta, PSC.

SELECT DISTINCT
	City.[name] AS NazevMesta,
	City.cityPostCode AS PSC
FROM BranchOffice
INNER JOIN OpuscardOrder ON
	(BranchOffice.branchOfficeId = OpuscardOrder.opuscardPickUpBranchOfficeId)
INNER JOIN OpuscardOrderState ON
(
	OpuscardOrderState.opuscardOrderStateId = OpuscardOrder.opuscardOrderStateId AND
	OpuscardOrderState.opuscardOrderStateName = 'Karta obdržena'
)
INNER JOIN City ON 
	(City.cityPostCode = BranchOffice.branchOfficeAddressCityPostCode);

-- 5. Vypište všechny pobočky, které vyrobily alespoň jednu kartu a zároveň si je nikdo nikdy nevybral jako výdejní místo pro vyrobenou kartu. Zahrňte i zrušené pobočky. Pro každou pobočku napište i počet vyrobených karet. Následně seřaďte podle počtu vyrobených karet sestupně a vypište ve formátu: NazevPobocky, NazevMesta, NazevUlice, CisloPopisne, PocetVyrobenychKaret. Nesmí se použít JOIN.

SELECT
	BranchOffice.branchOfficeName AS NazevPobocky,
	(
		SELECT City.[name]
		FROM City
		WHERE City.cityPostCode = BranchOffice.branchOfficeAddressCityPostCode
	)
	AS NazevMesta,
	BranchOffice.branchOfficeAddressStreetName AS NazevUlice,
	BranchOffice.branchOfficeAddressBuildingRegistryNumber AS CisloPopisne,
	(
		SELECT COUNT(*)
		FROM OpuscardOrder
		WHERE OpuscardOrder.opuscardProductionBranchOfficeId = BranchOffice.branchOfficeId
	)
	AS PocetVyrobenychKaret
FROM BranchOffice
WHERE BranchOffice.branchOfficeId IN
(
	SELECT DISTINCT OpuscardOrder.opuscardProductionBranchOfficeId
	FROM OpuscardOrder
	WHERE OpuscardOrder.opuscardProductionBranchOfficeId IS NOT NULL
	EXCEPT
	SELECT DISTINCT OpuscardOrder.opuscardPickUpBranchOfficeId
	FROM OpuscardOrder
	WHERE OpuscardOrder.opuscardPickUpBranchOfficeId IS NOT NULL
)
ORDER BY PocetVyrobenychKaret DESC;

-- 6. Vypište informaci, kolik uživatelů s potvrzeným emailem a zároveň potvrzeným mobilem, pokud ho mají, má validní tarifní kategorii "Držitel ZTP/P a ZTP" a zároveň platnou tarifní kategorii "Student -26". Nepoužívejte JOINY ani množinové operace ani ručně zadané ID. Vypište ve formátu: PocetStudujicichUzivateluSeZTP.

SELECT COUNT(*) AS PocetStudujicichUzivateluSeZTP
FROM RegisteredAccount
WHERE 
	RegisteredAccount.isEmailConfirmed = 1 AND
	(RegisteredAccount.registeredAccountPhone IS NULL OR RegisteredAccount.isPhoneConfirmed = 1) AND
	RegisteredAccount.registeredAccountEmail IN 
	(
		SELECT R1.registeredAccountEmail
		FROM RegisteredAccountTarifCategory R1
		WHERE
			R1.tarifCategoryId = 
			(
				SELECT TarifCategory.tarifCategoryId
				FROM TarifCategory
				WHERE TarifCategory.tarifCategoryName = 'Držitel ZTP/P a ZTP'
			) 
			AND
			R1.isTarifCategoryValid = 1
			AND
			R1.registeredAccountEmail IN 
			(
				SELECT R2.registeredAccountEmail
				FROM RegisteredAccountTarifCategory R2
				WHERE
					R2.tarifCategoryId = 
					(
						SELECT TarifCategory.tarifCategoryId
						FROM TarifCategory
						WHERE TarifCategory.tarifCategoryName = 'Student -26'
					) 
					AND
					R2.isTarifCategoryValid = 1
			)
	);

-- 7. Zjistěte, který typ časového kupónu (7denní, 30denní, atd.) v kombinaci s tarifní kategorií, je nejprodávanější za celou dobu. Využijte agregační funkci COUNT a GROUP BY a vypište všechny uživateli dosud vybrané kombinace typů kupónů a tarifních kategorií s počtem prodejů, následně seřaďte sestupně podle počtu prodejů. Prodej je myšleno, že kupón byl zaplacen. Tedy formát je: TypKuponuDny, NazevTarifniKategorie, PocetProdeju.

SELECT
	ProdaneCasoveKupony.timeCouponTypeDaysCount AS TypKuponuDny,
	(
		SELECT TarifCategory.tarifCategoryName
		FROM TarifCategory
		WHERE TarifCategory.tarifCategoryId = ProdaneCasoveKupony.tarifCategoryId
	) 
	AS NazevTarifniKategorie,
	COUNT(*) AS PocetProdeju
FROM
(
	SELECT 
		TimeCoupon.tarifCategoryId,
		TimeCoupon.timeCouponTypeDaysCount
	FROM TimeCoupon
	WHERE TimeCoupon.timeCouponOrderNumber IN 
	(
		SELECT TimeCouponOrder.timeCouponOrderNumber
		FROM TimeCouponOrder
		WHERE TimeCouponOrder.paymentDate IS NOT NULL
	)
) ProdaneCasoveKupony
GROUP BY 
	ProdaneCasoveKupony.timeCouponTypeDaysCount, 
	ProdaneCasoveKupony.tarifCategoryId
ORDER BY PocetProdeju DESC;

-- 8. Vypište pro každého uživatele, který je ve spojení s jiným uživatelem či uživateli, kolik ovládá uživatelů. Poté seřaďte sestupně dle počtu ovládaných uživatelů. Vypište ve formátu: EmailUzivatele, Jmeno, Prijmeni, PocetOvladanychUzivatelu.

SELECT
	OvladajiciUzivatele.linkedDestinationRegisteredAccountEmail AS EmailUzivatele, 
	OvladajiciUzivatele.forename AS Jmeno, 
	OvladajiciUzivatele.surname AS Prijmeni,
	COUNT(OvladajiciUzivatele.linkedDestinationRegisteredAccountEmail) AS PocetOvladanychUzivatelu
FROM 
(
	SELECT DISTINCT
		RegisteredAccountSharedWith.linkedDestinationRegisteredAccountEmail,
		(
			SELECT RegisteredAccount.forename
			FROM RegisteredAccount
			WHERE RegisteredAccount.registeredAccountEmail = RegisteredAccountSharedWith.linkedDestinationRegisteredAccountEmail
		) AS forename,
		(
			SELECT RegisteredAccount.surname
			FROM RegisteredAccount
			WHERE RegisteredAccount.registeredAccountEmail = RegisteredAccountSharedWith.linkedDestinationRegisteredAccountEmail
		) AS surname
	FROM RegisteredAccountSharedWith
) OvladajiciUzivatele
INNER JOIN RegisteredAccountSharedWith ON
	(OvladajiciUzivatele.linkedDestinationRegisteredAccountEmail = RegisteredAccountSharedWith.linkedDestinationRegisteredAccountEmail)
GROUP BY 
	OvladajiciUzivatele.linkedDestinationRegisteredAccountEmail,
	OvladajiciUzivatele.forename,
	OvladajiciUzivatele.surname
ORDER BY PocetOvladanychUzivatelu DESC;

-- 9. Vypište tarifní zóny, do kterých vede tři a více spojů. Pokuste se napsat dotaz bez použití HAVING nebo bez COUNT. Pozor na celosíťovku (TarifZoneNumber: "9999"). Vypište ve formátu: CisloZony, NazevZony.

SELECT
	(
		SELECT TZ.tarifZoneNumber
		FROM TarifZone TZ
		WHERE TarifniZony_Tri_A_Vice_Vstupnich_Spoju.connectedDestinationTarifZoneNumber = TZ.tarifZoneNumber
	)
	AS CisloZony,
	(
		SELECT TZ.tarifZoneName
		FROM TarifZone TZ
		WHERE TarifniZony_Tri_A_Vice_Vstupnich_Spoju.connectedDestinationTarifZoneNumber = TZ.tarifZoneNumber
	)
	AS NazevZony
FROM 
(
	SELECT DISTINCT T1.connectedDestinationTarifZoneNumber
	FROM TarifZoneConnectedWith T1
	INNER JOIN TarifZoneConnectedWith T2 ON
	(
		T1.connectedDestinationTarifZoneNumber = T2.connectedDestinationTarifZoneNumber AND 
		T2.connectedDestinationTarifZoneNumber <> T1.connectedSourceTarifZoneNumber AND
		T1.connectedSourceTarifZoneNumber < T2.connectedSourceTarifZoneNumber
	)
	INNER JOIN TarifZoneConnectedWith T3 ON 
	(
		T2.connectedDestinationTarifZoneNumber = T3.connectedDestinationTarifZoneNumber AND 
		T3.connectedDestinationTarifZoneNumber <> T1.connectedSourceTarifZoneNumber AND
		T3.connectedDestinationTarifZoneNumber <> T2.connectedSourceTarifZoneNumber AND
		T1.connectedSourceTarifZoneNumber < T3.connectedSourceTarifZoneNumber AND
		T2.connectedSourceTarifZoneNumber < T3.connectedSourceTarifZoneNumber
	)
) TarifniZony_Tri_A_Vice_Vstupnich_Spoju;

-- 10. Vypište pro každou tarifní kategorii, kolik celkově reálně zaplatili uživatelé za objednávky opuscard. Do výsledku započítavejte pouze objednávky uživatelů, kteří mají všechny své vybrané kategorie platné. Zahrňte i tarifní kategorie s nulovou celkovou cenou taky do výpisu. Následně seřaďte sestupně podle celkové ceny. Formát výpisu je: NazevTarifniKategorie, CelkovaCenaObjednavekOpuscard.

SELECT 
	TarifCategory.tarifCategoryName AS NazevTarifniKategorie,
	ISNULL(SUM(ProdaneObjednavkyOpuscard.price), 0) AS CelkovaCenaObjednavekOpuscard
FROM TarifCategory
LEFT JOIN
(
	SELECT 
		R1.tarifCategoryId,
		OpuscardOrder.price
	FROM RegisteredAccountTarifCategory R1
	INNER JOIN RegisteredAccount ON
	(
		RegisteredAccount.registeredAccountEmail = R1.registeredAccountEmail AND
		NOT EXISTS 
		(
			SELECT RegisteredAccountTarifCategory.tarifCategoryId
			FROM RegisteredAccountTarifCategory
			WHERE 
				RegisteredAccount.registeredAccountEmail = RegisteredAccountTarifCategory.registeredAccountEmail AND
				RegisteredAccountTarifCategory.isTarifCategoryValid = 0

		)
	)
	INNER JOIN OpuscardOrder ON
	(
		OpuscardOrder.registeredAccountEmail = RegisteredAccount.registeredAccountEmail AND
		OpuscardOrder.paymentDate IS NOT NULL
	)
) 
ProdaneObjednavkyOpuscard ON
	(TarifCategory.tarifCategoryId = ProdaneObjednavkyOpuscard.tarifCategoryId)
GROUP BY TarifCategory.tarifCategoryName
ORDER BY CelkovaCenaObjednavekOpuscard DESC;

-- 11. Vypište tarifní zóny, do kterých vede spoj či spoje, které se skládají z tří a více mezicest. Nejsou povoleny mezicesty, které tvoří uzavřenou kružnici v rámci grafu. Pozor na celosíťovku (TarifZoneNumber: "9999"). Pokuste se napsat dotaz bez použití HAVING nebo bez COUNT. Vypište ve formátu: CisloZony, NazevZony.

SELECT
	(
		SELECT TZ.tarifZoneNumber
		FROM TarifZone TZ
		WHERE TarifniZony_Tri_A_Vice_MeziCest.connectedDestinationTarifZoneNumber = TZ.tarifZoneNumber
	)
	AS CisloZony,
	(
		SELECT TZ.tarifZoneName
		FROM TarifZone TZ
		WHERE TarifniZony_Tri_A_Vice_MeziCest.connectedDestinationTarifZoneNumber = TZ.tarifZoneNumber
	)
	AS NazevZony
FROM 
(
	SELECT DISTINCT T1.connectedDestinationTarifZoneNumber
	FROM TarifZoneConnectedWith T1
	INNER JOIN TarifZoneConnectedWith T2 ON
	(
		T1.connectedSourceTarifZoneNumber = T2.connectedDestinationTarifZoneNumber AND 
		T1.connectedDestinationTarifZoneNumber <> T2.connectedSourceTarifZoneNumber
	)
	INNER JOIN TarifZoneConnectedWith T3 ON
	(
		T2.connectedSourceTarifZoneNumber = T3.connectedDestinationTarifZoneNumber AND 
		T2.connectedDestinationTarifZoneNumber <> T3.connectedSourceTarifZoneNumber AND
		T1.connectedDestinationTarifZoneNumber <> T3.connectedSourceTarifZoneNumber
	)
) TarifniZony_Tri_A_Vice_MeziCest;

-- 12. Najděte rozdíl mezi průměrnou cenou objednávek časových kupónů zakoupených před rokem 2020 a průměrnou cenu objednávek časových kupónů zakoupených od roku 2020. Ujistěte se, že jste spočítali průměrnou cenu nejdříve pro každou objednávku časových kupónů a pak průměr těchto průměrů před rokem 2020 a po roce 2020. Vypište ve formátu: RozdilPrumernychCenObjednavekKuponuPred_2020_Po_2020.

SELECT
(
	SELECT 
	(
		SELECT AVG(prumerne_ceny_objednavky_kuponu.prumerna_cena)
		FROM 
		(
			SELECT 
				TC.timeCouponOrderNumber AS timeCouponOrderNumber,
				(
					SELECT TimeCouponOrder.paymentDate
					FROM TimeCouponOrder
					WHERE TimeCouponOrder.timeCouponOrderNumber = TC.timeCouponOrderNumber
				) AS datumCasPlatby,
				AVG(TC.price) AS prumerna_cena
			FROM TimeCoupon TC
			WHERE TC.timeCouponOrderNumber IN 
			(
				SELECT TimeCouponOrder.timeCouponOrderNumber
				FROM TimeCouponOrder
				WHERE TimeCouponOrder.paymentDate IS NOT NULL
			)
			GROUP BY TC.timeCouponOrderNumber
		) prumerne_ceny_objednavky_kuponu
		WHERE prumerne_ceny_objednavky_kuponu.datumCasPlatby < '2020-01-01 00:00:00'	
	) -
	(
		SELECT AVG(prumerne_ceny_objednavky_kuponu.prumerna_cena)
		FROM 
		(
			SELECT 
				TC.timeCouponOrderNumber AS timeCouponOrderNumber,
				(
					SELECT TimeCouponOrder.paymentDate
					FROM TimeCouponOrder
					WHERE TimeCouponOrder.timeCouponOrderNumber = TC.timeCouponOrderNumber
				) AS datumCasPlatby,
				AVG(TC.price) AS prumerna_cena
			FROM TimeCoupon TC
			WHERE TC.timeCouponOrderNumber IN 
			(
				SELECT TimeCouponOrder.timeCouponOrderNumber
				FROM TimeCouponOrder
				WHERE TimeCouponOrder.paymentDate IS NOT NULL
			)
			GROUP BY TC.timeCouponOrderNumber
		) prumerne_ceny_objednavky_kuponu
		WHERE prumerne_ceny_objednavky_kuponu.datumCasPlatby >= '2020-01-01 00:00:00'
	)
) AS RozdilPrumernychCenObjednavekKuponuPred_2020_Po_2020;