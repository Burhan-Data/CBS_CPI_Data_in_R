CBS_CPI_Data_in_R
## Consumentenprijsindex (CPI) Analyseproces in R
## Overzicht
#Dit repository bevat een op zichzelf staand R-script dat consumentenprijsgegevens rechtstreeks ophaalt uit de CBS StatLine API, de maandgegevens verwerkt tot kwartaalgemiddelden, de procentuele veranderingen van kwartaal op kwartaal berekent, de resultaten plot en alles archiveert in een lokale SQLite-database.
## Tools en afhankelijkheden
1. **Taal:** R
2. **Data Wrangling:** `dplyr`, `tidyr`, `stringr`
3. **Visualisatie:** `ggplot2`
4. **Database:** `RSQLite`, `DBI`

## Procesarchitectuur
1. **Invoer:** Haalt automatisch de nieuwste officiële CPI-tabel (86141ENG) rechtstreeks op via de webservice van CBS StatLine zonder handmatige bestanddownloads.
2. **Invoer 2** Controleer uitsluitend de CPI voor Voeding en niet-alcoholische dranken (CPI010000) en Gezondheid (CPI060000).
3. **Verwerking:** Filtert de door de gebruiker geselecteerde productcategorieën, groepeert maandelijkse indexen in blokken van 3 maanden om het gemiddelde kwartaal-CPI te berekenen, en berekent de procentuele groei ten opzichte van het voorgaande kwartaal.
4. **Uitvoer:** Genereert een publicatieklaar lijndiagram (output_cpi_quarterly_change.png) en schrijft de opgeschoonde dataset weg naar een lokale SQLite-database (cpi_database.sqlite).

## Hoe te starten
1. Open het project in RStudio.
2. Voer install.packages(c("cbsodataR", "dplyr", "tidyr", "ggplot2", "DBI", "RSQLite", "stringr", "writexl")) uit als er pakketten ontbreken..
3. Voer het hoofd-R-script uit.
