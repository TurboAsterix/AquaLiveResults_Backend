/* AquaLiveResults Backend - Aquarius SQL Query - www.aqualiveresults.de */
DECLARE @Event_ID_test INT = 18
DECLARE @Comp_State_Official TINYINT = 4 
DECLARE @Offer_Cancelled BIT = 1

SELECT
/*  Event -> Veranstaltung */ 
	Event.Event_ID						AS Event_ID_Int,    

/*  Offer -> Ausschreibung */ 
	Offer.Offer_RaceNumber				AS Race_Number, 
	Offer.Offer_ShortLabel				AS Race_Title_Short,
	Offer.Offer_LongLabel				AS Race_Title_Long,
	Offer.Offer_SortValue				AS Race_SortValue,

/*  Comp -> Läufe */
	Comp.Comp_ID						AS Comp_ID_Int,
	Comp.Comp_Number					AS Comp_Number,
	Comp.Comp_HeatNumber				AS Comp_HeatNumber_Int,

/*  RoundCode -> Hauptrennen/Leistungsgruppen/Alterklassen oder Abteilung */
	CASE Comp_RoundCode WHEN 'R' THEN CONCAT(Offer.Offer_ShortLabel, ' - ', 'Hpt. ', Comp_Label, ' ',
												CASE Comp_GroupValue WHEN '0' THEN 'LG I'
												                     WHEN '1' THEN 'LG II'
																	 WHEN '2' THEN 'LG III'
																	 WHEN '4' THEN 'AK A'
																	 WHEN '5' THEN 'AK B' END, ' ' )
	                    WHEN 'A' THEN CONCAT(Offer.Offer_ShortLabel, ' - ', 'Abt. ', Comp_Label, ' ',
												CASE Comp_GroupValue WHEN '0' THEN 'LG I'
												                     WHEN '1' THEN 'LG II'
																	 WHEN '2' THEN 'LG III'
																	 WHEN '4' THEN 'AK A'
																	 WHEN '5' THEN 'AK B' END, ' ' )
						ELSE Offer.Offer_ShortLabel  END                                             AS Comp_Text, 
    
/*  Label -> generisch, Vereine zu Läufen */ 
	IIF (Offer.Offer_Cancelled = 1, 'Rennen nicht zu Stande gekommen', Label.Label_Long)             AS Crew_Club_Long,
	IIF (Offer.Offer_Cancelled = 1, 'Rennen nicht zu Stande gekommen', Label.Label_Short)		     AS Crew_Club_Short,

/*	CE_Lane -> Bahn */
	CompEntries.CE_Lane					                                                             AS Comp_Lane_Int,

/*  Result -> Ergebnisse eines Laufes */ 
/*  Rang 0 ersetzen durch NULL -> Kein Rang */
	IIF (Result.Result_Rank = 0, NULL, Result_Rank)                                                  AS Result_Rank_Int,
/*  Boot abgemeldet ODER DNF/DNS/EXC/xxx (kein : in Ergebniszeit) -> Rang 99 */
	IIF (Entry.Entry_CancelValue = 10 OR Result.Result_DisplayValue NOT LIKE '%:%', 99, Result_Rank) AS Result_Rank_Sort, 
/*  Boot abgemeldet -> Ergebniszeit �berschreiben mit Abgemeldet */
	CASE Entry.Entry_CancelValue WHEN 10 THEN 'Abgemeldet' ELSE Result.Result_DisplayValue END       AS Result_Time,

/*  Crew Athlet -> Mannschaft, Ruderer, Steuermann incl. Verein und Jahrgang */ 
	MAX( IIF (Crew.Crew_Pos = '1' AND Crew.Crew_IsCox = 0, CONCAT(Athlet.Athlet_FirstName, ' ', Athlet.Athlet_LastName, ' (', AthletClub.Club_UltraAbbr, ', ', YEAR(Athlet.Athlet_DOB), ')'), '')) AS Athlet1_FormattedName,
	MAX( IIF (Crew.Crew_Pos = '2' AND Crew.Crew_IsCox = 0, CONCAT(Athlet.Athlet_FirstName, ' ', Athlet.Athlet_LastName, ' (', AthletClub.Club_UltraAbbr, ', ', YEAR(Athlet.Athlet_DOB), ')'), '')) AS Athlet2_FormattedName,
	MAX( IIF (Crew.Crew_Pos = '3' AND Crew.Crew_IsCox = 0, CONCAT(Athlet.Athlet_FirstName, ' ', Athlet.Athlet_LastName, ' (', AthletClub.Club_UltraAbbr, ', ', YEAR(Athlet.Athlet_DOB), ')'), '')) AS Athlet3_FormattedName,
	MAX( IIF (Crew.Crew_Pos = '4' AND Crew.Crew_IsCox = 0, CONCAT(Athlet.Athlet_FirstName, ' ', Athlet.Athlet_LastName, ' (', AthletClub.Club_UltraAbbr, ', ', YEAR(Athlet.Athlet_DOB), ')'), '')) AS Athlet4_FormattedName,
	MAX( IIF (Crew.Crew_Pos = '5' AND Crew.Crew_IsCox = 0, CONCAT(Athlet.Athlet_FirstName, ' ', Athlet.Athlet_LastName, ' (', AthletClub.Club_UltraAbbr, ', ', YEAR(Athlet.Athlet_DOB), ')'), '')) AS Athlet5_FormattedName,
	MAX( IIF (Crew.Crew_Pos = '6' AND Crew.Crew_IsCox = 0, CONCAT(Athlet.Athlet_FirstName, ' ', Athlet.Athlet_LastName, ' (', AthletClub.Club_UltraAbbr, ', ', YEAR(Athlet.Athlet_DOB), ')'), '')) AS Athlet6_FormattedName,
	MAX( IIF (Crew.Crew_Pos = '7' AND Crew.Crew_IsCox = 0, CONCAT(Athlet.Athlet_FirstName, ' ', Athlet.Athlet_LastName, ' (', AthletClub.Club_UltraAbbr, ', ', YEAR(Athlet.Athlet_DOB), ')'), '')) AS Athlet7_FormattedName,
	MAX( IIF (Crew.Crew_Pos = '8' AND Crew.Crew_IsCox = 0, CONCAT(Athlet.Athlet_FirstName, ' ', Athlet.Athlet_LastName, ' (', AthletClub.Club_UltraAbbr, ', ', YEAR(Athlet.Athlet_DOB), ')'), '')) AS Athlet8_FormattedName,
	MAX( IIF (Crew.Crew_IsCox = 1,                         CONCAT(Athlet.Athlet_FirstName, ' ', Athlet.Athlet_LastName, ' (', AthletClub.Club_UltraAbbr, ', ', YEAR(Athlet.Athlet_DOB), ')'), '')) AS Cox_FormattedName


/* -------------------------------------------------------------------------------------------------------------------- */
FROM
/* -------------------------------------------------------------------------------------------------------------------- */


/*  Main event; only Event ID needed from Where Clause, based on Aquarius.ini in Windows Profile */
	Event

/*  Get offered races -> Ausschreibung */
	LEFT JOIN Offer                ON Offer.Offer_Event_ID_FK   = Event.Event_ID 

/*  Get comp -> Läufe */  
	LEFT JOIN Comp                 ON Comp.Comp_Event_ID_FK     = Event.Event_ID
                                  AND Comp.Comp_Race_ID_FK      = Offer.Offer_ID

/*  Get entries -> Einträge für Läufe */ 
	LEFT JOIN CompEntries          ON CompEntries.CE_Comp_ID_FK = Comp.Comp_ID

/*  Get entries / Master Data -> Stammdaten */
	LEFT JOIN Entry			   	   ON Entry.Entry_ID            = CompEntries.CE_Entry_ID_FK
	LEFT JOIN EntryLabel           ON EntryLabel.EL_Entry_ID_FK = Entry.Entry_ID
	                              AND EntryLabel.EL_RoundFrom  <= Comp.Comp_Round 
					              AND EntryLabel.EL_RoundTo    >= Comp.Comp_Round
    LEFT JOIN Label                ON Label.Label_ID            = EntryLabel.EL_Label_ID_FK

/*	Finally, get the result -> Ergebnisse */ 
	LEFT JOIN Result 			   ON Result.Result_CE_ID_FK	= CompEntries.CE_ID
	                              AND Result.Result_SplitNr     = 64

/*  Get Crews -> An der Abteilung teilnehmende Vereine */ 
    LEFT JOIN Club AS CrewClub     ON CrewClub.Club_ID          = Label.Label_Club_ID_FK
    LEFT JOIN Nation AS CrewNation ON CrewNation.Nation_ID      = CrewClub.Club_Nation_ID_FK


	LEFT JOIN Crew AS Crew         ON Crew.Crew_Entry_ID_FK     = CompEntries.CE_Entry_ID_FK
                                  AND Crew.Crew_RoundFrom      <= Comp.Comp_Round 
								  AND Crew.Crew_RoundTo        >= Comp.Comp_Round

/*  Get Athlets -> An der Mannschaft teilnehmende Ruderer */ 
	LEFT JOIN Athlet AS Athlet     ON Athlet.Athlet_ID          = Crew.Crew_Athlete_ID_FK

/*  Get Clubs -> Vereine der Ruderer (->Renngemeinschaften) */ 
	LEFT JOIN Club AS AthletClub   ON AthletClub.Club_ID        = Athlet.Athlet_Club_ID_FK


/* -------------------------------------------------------------------------------------------------------------------- */
WHERE
/* -------------------------------------------------------------------------------------------------------------------- */
/*                             Event_ID_test for testing */
	        Event_ID        = @Event_ID         
	AND ( ( Comp.Comp_State = @Comp_State_Official )
/*   Entkommentieren für Nicht zustande gekommene Rennen */
/* 	 OR   ( Offer.Offer_SortValue <= ( SELECT MAX(Offer.Offer_SortValue)
			  	  			   	         FROM [Rudern].[dbo].[Offer]
								         JOIN Comp
										   ON Comp.Comp_Event_ID_FK     = Event.Event_ID
									      AND Comp.Comp_Race_ID_FK      = Offer.Offer_ID
									     JOIN CompEntries
								  	       ON CompEntries.CE_Comp_ID_FK = Comp.Comp_ID  
									     JOIN result 
										   ON Result.Result_CE_ID_FK	 = CompEntries.CE_ID 
									      AND Result.Result_SplitNr     = 64 ) 
	AND 	Offer.Offer_Cancelled = @Offer_Cancelled ) */
		)
		 

/* -------------------------------------------------------------------------------------------------------------------- */
GROUP BY
/* -------------------------------------------------------------------------------------------------------------------- */
	Event.Event_ID,        
/*  Offer -> Ausschreibung */ 
	Offer.Offer_RaceNumber, 
	Offer.Offer_SortValue,
	Offer.Offer_ShortLabel,
	Offer.Offer_LongLabel,
	Offer.Offer_Cancelled,
/*  Comp -> Läufe / Abteilungen */ 
	Comp.Comp_ID,
	Comp.Comp_Number,
	Comp.Comp_HeatNumber,
	Comp.Comp_RoundCode,
	Comp.Comp_Label,
	Comp.Comp_GroupValue,
    CompEntries.CE_Lane,
	Entry_CancelValue,
/*  Label -> generisch, Vereine zu Läufen */ 
	Label.Label_Long,
	Label.Label_Short,
/*  Result -> Ergebnisse eines Laufes */ 
	Result.Result_Rank,
	Result.Result_DisplayValue


/* -------------------------------------------------------------------------------------------------------------------- */
ORDER BY 
/* -------------------------------------------------------------------------------------------------------------------- */
    Event_ID_Int,
    Offer.Offer_SortValue DESC, 
	Race_Number           DESC, 
	Comp_Number           DESC,
	Comp_HeatNumber_Int,
	Result_Rank_Sort,                 /* enthält Rang 99 für Abgemeldet/DNS/DNF/EXC */
	Comp_Lane_Int