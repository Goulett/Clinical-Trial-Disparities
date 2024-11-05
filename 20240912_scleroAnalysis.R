# title: "Analysis of Disparity Between Scleroderma Clinical Trial Participant
#   Demographics and Scleroderma Patient Demographics in the United States"
# author: "Natalie Goulett"
# date: 2024-09-12

# Note: This is the R code copied from my full analysis report in the
#   US_Scleroderma_Clinical_Trial_Disparities_Analysis.qmd file. Please see the 
#   associated .qmd or .docx for the full report.



# Install and load required packages -----

# install.packages("tidyverse")
# install.packages("gt")
library(tidyverse)  # for data wrangling and visualization
library(gt) # for creating table


# Read and transform data -----

ct_demo_df <- read_csv(
  "./Data/20240717_usSScClinTrialDemo.csv",
  col_names = TRUE,
  na = c("#N/A", "#NA", "Not Reported", "Not reported")) %>% 
  rename(
    "total_participants" = "Number of participants analyzed - use this number for total participants",
    "female" = "Female",
    "male" = "Male",
    "other_gender" = "Other",
    "study_ID" = "ClinicalTrials.gov ID",
    "hispanic" = "Hispanic or Latino",
    "non_hispanic" = "Not Hispanic or Latino",
    "unknown_ethnicity" = "Unknown or not reported ethnicity",
    "native_american_an" = "American Indian or Alaska Native",
    "asian" = "Asian",
    "native_hawaiian_pi" = "Native Hawaiian or Other Pacific Islander",
    "black_participants" = "Black or African American",
    "white_participants" = "White",
    "multi_race" = "More than one race",
    "unknown_race" = "Unknown or not reported"
  ) %>% 
  drop_na(total_participants, black_participants)


# Demographics Calculations -----

# total U.S. clinical trial participants
ct_n <-  sum(ct_demo_df$total_participants, na.rm = TRUE)

# Summarize participants by race, gender, and ethnicity
race_summary <- ct_demo_df %>%
  summarise(
    total_black = sum(black_participants, na.rm = TRUE),
    total_white = sum(white_participants, na.rm = TRUE),
    total_native_american_an = sum(native_american_an, na.rm = TRUE),
    total_native_hawaiian_pi = sum(native_hawaiian_pi, na.rm = TRUE),
    total_asian = sum(asian, na.rm = TRUE),
    total_multi_race = sum(multi_race, na.rm = TRUE),
    total_unknown_race = sum(unknown_race, na.rm = TRUE),
    percent_black = (total_black / ct_n) * 100,
    percent_white = (total_white / ct_n) * 100,
    percent_native_american_an = (total_native_american_an / ct_n) * 100,
    percent_native_hawaiian_pi = (total_native_hawaiian_pi / ct_n) * 100,
    percent_asian = (total_asian / ct_n) * 100,
    percent_multi_race = (total_multi_race / ct_n) * 100,
    percent_unknown_race = (total_unknown_race / ct_n) * 100,
    total_reporting_race = sum(
      total_black,
      total_white,
      total_native_american_an,
      total_native_hawaiian_pi,
      total_asian,
      total_multi_race
    )
  )

gender_summary <- ct_demo_df %>% 
  summarise(
    total_male = sum(male, na.rm = TRUE),
    total_female = sum(female, na.rm = TRUE),
    percent_male = (total_male / ct_n) * 100,
    percent_female = (total_female / ct_n) * 100
  )

ethnicity_summary <- ct_demo_df %>%
  summarise(
    total_hispanic = sum(hispanic, na.rm = TRUE),
    total_non_hispanic = sum(non_hispanic, na.rm = TRUE),
    total_unknown_ethnicity = sum(unknown_ethnicity, na.rm = TRUE),
    total_reporting_ethnicity = sum(total_hispanic, total_non_hispanic),
    percent_hispanic = (total_hispanic / total_reporting_ethnicity) * 100,
    percent_non_hispanic = (total_non_hispanic / total_reporting_ethnicity) * 100
  )

# Combine summaries into one data frame
demographics_df <- bind_cols(
  race_summary,
  gender_summary,
  ethnicity_summary
) %>% 
  pivot_longer(cols = everything())

print(demographics_df, n = 25)


# Chi-square test of proportion of US clinical trial participants who are black  -----
#   vs. US scleroderma patients

# calculate number of black U.S. clinical trial participants
ct_n_black <- sum(ct_demo_df$black_participants, na.rm = TRUE)
# calculate number of non-black U.S. clinical trial participants
ct_n_nonblack <- ct_n - ct_n_black

# Input demographics of patient population characterized in Mayes et al., 2003
mayes_n <- 706
mayes_n_black <- 186
mayes_n_nonblack <- mayes_n - mayes_n_black

# Create contingency table of expected and observed demographics
demo_contingency_table <- matrix(
  c(
    ct_n_black,
    mayes_n_black,
    ct_n_nonblack,
    mayes_n_nonblack
  ),
  nrow = 2
)

colnames(demo_contingency_table) <- c("Black", "Non-Black")
rownames(demo_contingency_table) <- c(
  "Clinical Trial Participants",
  "Scleroderma Patients"
)

demo_chi_sq <- chisq.test(
  demo_contingency_table,
  correct = TRUE
)

print(demo_chi_sq)
