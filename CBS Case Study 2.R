# CASE 1: R ASSIGNMENT - STATLINE CPI ANALYSIS
install.packages(c("cbsodataR", 
                   "RSQLite", 
                   "DBI", 
                   "dplyr", 
                   "tidyr", 
                   "ggplot2", 
                   "stringr",
                   "writexl"
)
)
# Load required libraries
library(cbsodataR)
library(dplyr)
library(tidyr)
library(ggplot2)
library(DBI)
library(RSQLite)
library(stringr)
library(writexl)

# 1. INPUT SECTION: Retrieve data directly from CBS StatLine
fetch_statline_data <- function(table_id = "86141ENG") {
  raw_data <- cbs_get_data(table_id)
  return(raw_data)
}

# Execute Input
cpi_raw <- fetch_statline_data("86141ENG")

# Check and Understand the Data with Excel if its necessary
#write_xlsx(cpi_raw, "cpi_raw_data.xlsx")
#getwd()


# 2. THROUGHPUT SECTION: Transformation and Custom Calculation Function

clean_cpi_data <- function(cpi_raw) {
  cpi_raw %>%
    select(ExpenditureCategories, Periods, CPI_1) %>%
    filter(ExpenditureCategories %in% c("CPI010000", "CPI060000")) %>%
    filter(!str_detect(Periods, "JJ00$")) %>%
    mutate(
      Month_Num = as.numeric(str_sub(Periods, -2)),
      Quarter = paste0("Q", ceiling(Month_Num / 3))
    ) %>%
    select(-Month_Num) %>%
    mutate(Year = str_sub(Periods, 1, 4)) %>%
    group_by(ExpenditureCategories, Year, Quarter) %>%
    summarise(
      CPI_Q = mean(CPI_1, na.rm = TRUE),
      .groups = "drop"
    )
}

cpi_quarterly <- clean_cpi_data(cpi_raw)

#OUTPUT

# Create the line plot
chart_output <- cpi_quarterly %>%
  # Combine Year and Quarter to create a continuous X-axis time variable (e.g., "2024-Q1")
  mutate(Time = paste0(Year, "-", Quarter)) %>%
  ggplot(aes(x = Time, y = CPI_Q, color = ExpenditureCategories, group = ExpenditureCategories)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  # Map the raw codes to your user-friendly legend labels
  scale_color_manual(
    values = c("CPI010000" = "#2E86C1", "CPI060000" = "#E74C3C"),
    labels = c("CPI010000" = "Food and Beverages", 
               "CPI060000" = "Health")
  ) +
  theme_minimal() +
  labs(
    title = "CPI of Food and Health",
    x = "Quarterly Time Series",
    y = "Quarterly Average CPI",
    color = "Category"
  ) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1), # Rotate X labels so they don't overlap
    plot.title = element_text(face = "bold", size = 14)
  )

print(chart_output)

ggsave("cpi_food_health.png", 
       plot = chart_output, 
       width = 10, 
       height = 6, 
       dpi = 300
)

# Store Results in a Local SQLite Database
save_to_sqlite <- function(data, db_name = "cpi_database.sqlite") {
  message("Saving processed results to SQLite database...")
  conn <- dbConnect(RSQLite::SQLite(), db_name)
  
  # Write table to database
  dbWriteTable(conn, "quarterly_cpi_changes", data, overwrite = TRUE)
  
  # Verify connection and data
  tables <- dbListTables(conn)
  print(paste("Tables in SQLite DB:", paste(tables, collapse = ", ")))
  
  dbDisconnect(conn)
}

processed_data <- cpi_quarterly

save_to_sqlite(processed_data)

getwd()
