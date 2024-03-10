-- 1. Vypište všechna kontaktní místa IDOL, která vyrobila alespoň jednu opuscard kartu. Každou pobočku vypište ve formátu: NazevPobocky, NazevMesta, NazevUlice, CisloPopisne. Součástí výpisu můžou být i zrušené pobočky.

-- 2. Vypište všechny časové kupóny, které byly úspěšně zaplaceny a zároveň zakoupeny v letech 2019 a výše. Pro každý kupón vypište ve formátu: CisloOpuscard, EmailMajiteleOpuscard, IdKuponu, DatumCasZaplaceniKuponu, CenaKuponu, CisloObjednavky.

-- 3. Vypište všechny uživatele s potvrzeným emailem a zároveň potvrzeným mobilem, pokud ho mají, kteří mají vybranou ověřenou tarifní kategorii obsahující "ZTP" nebo ověřenou kategorii obsahující "Důchodce" a zároveň s někým sdíleli alespoň jednou svůj účet. Pro každého uživatele vypište ve formátu: EmailUzivatele, Jmeno, Prijmeni.

-- 4. Vypište všechna města, ve kterých si uživatelé veřejné dopravy alespoň jednou reálně vyzvedli (stav objednávky: "Karta obdržena") opuscard kartu na pobočce. Zahrňte i zrušené pobočky. Vypište ve formátu: NazevMesta, PSC.

-- 5. Vypište všechny pobočky, které vyrobily alespoň jednu kartu a zároveň si je nikdo nikdy nevybral jako výdejní místo pro vyrobenou kartu. Zahrňte i zrušené pobočky. Pro každou pobočku napište i počet vyrobených karet. Následně seřaďte podle počtu vyrobených karet sestupně a vypište ve formátu: NazevPobocky, NazevMesta, NazevUlice, CisloPopisne, PocetVyrobenychKaret. Nesmí se použít JOIN.

-- 6. Vypište informaci, kolik uživatelů s potvrzeným emailem a zároveň potvrzeným mobilem, pokud ho mají, má validní tarifní kategorii "Držitel ZTP/P a ZTP" a zároveň platnou tarifní kategorii "Student -26". Nepoužívejte JOINY ani množinové operace ani ručně zadané ID. Vypište ve formátu: PocetStudujicichUzivateluSeZTP.

-- 7. Zjistěte, který typ časového kupónu (7denní, 30denní, atd.) v kombinaci s tarifní kategorií, je nejprodávanější za celou dobu. Využijte agregační funkci COUNT a GROUP BY a vypište všechny uživateli dosud vybrané kombinace typů kupónů a tarifních kategorií s počtem prodejů, následně seřaďte sestupně podle počtu prodejů. Prodej je myšleno, že kupón byl zaplacen. Tedy formát je: TypKuponuDny, NazevTarifniKategorie, PocetProdeju.

-- 8. Vypište pro každého uživatele, který je ve spojení s jiným uživatelem či uživateli, kolik ovládá uživatelů. Poté seřaďte sestupně dle počtu ovládaných uživatelů. Vypište ve formátu: EmailUzivatele, Jmeno, Prijmeni, PocetOvladanychUzivatelu.

-- 9. Vypište tarifní zóny, do kterých vede tři a více spojů. Pokuste se napsat dotaz bez použití HAVING nebo bez Count. Pozor na celosíťovku (TarifZoneNumber: "9999"). Vypište ve formátu: CisloZony, NazevZony.

-- 10. Vypište pro každou tarifní kategorii, kolik celkově reálně zaplatili uživatelé za objednávky opuscard. Do výsledku započítavejte pouze objednávky uživatelů, kteří mají všechny své vybrané kategorie platné. Zahrňte i tarifní kategorie s nulovou celkovou cenou taky do výpisu. Následně seřaďte sestupně podle celkové ceny. Formát výpisu je: NazevTarifniKategorie, CelkovaCenaObjednavekOpuscard.

-- 11. Vypište tarifní zóny, do kterých vede spoj či spoje, které se skládají z tří a více mezicest. Nejsou povoleny mezicesty, které tvoří uzavřený kruh v rámci grafu. Pozor na celosíťovku (TarifZoneNumber: "9999"). Pokuste se napsat dotaz bez použití HAVING nebo bez Count. Vypište ve formátu: CisloZony, NazevZony.

-- 12. Najděte rozdíl mezi průměrnou cenou objednávek časových kupónů zakoupených před rokem 2020 a průměrnou cenu objednávek časových kupónů zakoupených od roku 2020. Ujistěte se, že jste spočítali průměrnou cenu nejdříve pro každou objednávku časových kupónů a pak průměr těchto průměrů před rokem 2020 a po roce 2020. Vypište ve formátu: RozdilPrumernychCenObjednavekKuponuPred_2020_Po_2020.