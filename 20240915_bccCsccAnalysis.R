# title: Underepresentation of Black Individuals with Basal Cell Carcinoma (BCC)
#   and Cutaneous Squamous Cell Carcinoma (cSCC) in U.S. Clinical Trials:  A
#   Comparison of the Demographics of Clinical Trial Participants to Those of an
#   Insurance Claimant Cohort in the United States'
# author: Natalie Goulett
# date: 2024-09-15

# Note: This is the R code copied from my full analysis report in the
#   US_BCC_and_CSCC_Clinical_Trial_Disparities_Analysis.qmd file. Please see the 
#   associated .qmd or .docx for the full report.



# install-packages -----

# install.packages("tidyverse")
# install.packages("extrafont") # optional
library(tidyverse)  # for data wrangling
library(extrafont)  # To use more fonts in graphs (optional)


# read and transform BCC data -----

# read BCC US clinical trial demographic data
bccCtDemo_df <- read_csv(
  "./Data/20240830_bccUsctDemog.csv",
  col_names = TRUE,
  na = c("#N/A", "#NA", "Not Reported", "Not reported"),
  show_col_types = FALSE
) %>%
  rename(
    "total_participants" = "Number of participants analyzed",
    "study_ID" = "ClinicalTrials.gov ID",
    "black_participants" = "Black or African American",
    "white_participants" = "White"
  ) %>%
  select(
    c(
      "study_ID",
      "total_participants",
      "black_participants",
      "white_participants"
    )
  ) %>% 
  filter(!is.na(black_participants) | !is.na(white_participants)
  )

# calculate total participants
bcc_ct_n <- sum(bccCtDemo_df$total_participants, na.rm = TRUE)
# calculate number of Black participants
bcc_ct_n_black <- sum(bccCtDemo_df$black_participants, na.rm = TRUE)
# calculate number of non-Black participants
bcc_ct_n_nonblack <- bcc_ct_n - bcc_ct_n_black

# Demographics from Lukowiak, et al.:
# total number of claimants
bcc_claim_n <- 618516
# number of Black claimants
bcc_claim_n_black <- 23315
# number of non-Black claimants
bcc_claim_n_nonblack <- bcc_claim_n - bcc_claim_n_black

# Create contingency table of expected and observed BCC patient demographics
bcc_demo_contingency_table <- matrix(
  c(
    bcc_ct_n_nonblack,
    bcc_claim_n_nonblack,
    bcc_ct_n_black,
    bcc_claim_n_black
  ),
  nrow = 2
)

colnames(bcc_demo_contingency_table) <- c(
  "BCC Claimants",
  "BCC Clinical Trial Participants"
)
rownames(bcc_demo_contingency_table) <- c(
  "Black Patients",
  "Non-Black Patients"
)


# BCC Chi-square test -----

# conduct Chi-square test to compare BCC clinical trial vs. insurance claimant
#   demographics
bcc_demo_chi_sq <- chisq.test(
  bcc_demo_contingency_table,
  correct = TRUE
)

print(bcc_demo_chi_sq)


# read and transform cSCC data -----

# read cSCC U.S. clinical trial demographic data
csccCtDemo_df <- read_csv(
  "./Data/20240829_csccUsctDemog.csv",
  col_names = TRUE,
  na = c("#N/A", "#NA", "Not Reported", "Not reported"),
  show_col_types = FALSE
) %>%
  rename(
    "total_participants" = "Number of participants analyzed",
    "study_ID" = "ClinicalTrials.gov ID",
    "black_participants" = "Black or African American",
    "white_participants" = "White"
  ) %>%
  select(
    c(
      "study_ID",
      "total_participants",
      "black_participants",
      "white_participants"
    )
  ) %>% 
  filter(!is.na(black_participants) | !is.na(white_participants)
  )

# calculate total participants
cscc_ct_n <- sum(csccCtDemo_df$total_participants, na.rm = TRUE)
# calculate number of Black participants
cscc_ct_n_black <- sum(csccCtDemo_df$black_participants, na.rm = TRUE)
# calculate number of non-Black participants
cscc_ct_n_nonblack <- cscc_ct_n - cscc_ct_n_black

# Demographics from Lukowiak, et al.:
# total number of claimants
cscc_claim_n <- 366801
# number of Black claimants
cscc_claim_n_black <- 16070
# number of non-Black claimants
cscc_claim_n_nonblack <- cscc_claim_n - cscc_claim_n_black

# Create contingency table of expected and observed cSCC patient demographics
cscc_demo_contingency_table <- matrix(
  c(
    cscc_ct_n_nonblack,
    cscc_claim_n_nonblack,
    cscc_ct_n_black,
    cscc_claim_n_black
  ),
  nrow = 2
)

colnames(cscc_demo_contingency_table) <- c(
  "cSCC Claimants",
  "cSCC Clinical Trial Participants"
)
rownames(cscc_demo_contingency_table) <- c(
  "Black Patients",
  "Non-Black Patients"
)


# cSCC Chi-square test -----

# conduct Chi-Square test to compare cSCC clinical trial vs. insurance claimant
#   demographics
cscc_demo_chi_sq <- chisq.test(
  cscc_demo_contingency_table,
  correct = TRUE
)

print(cscc_demo_chi_sq)


# Black representation in US BCC and cSCC Clinical Trials -----

# calculate proportion of BCC clinical trial participants who are Black
bcc_ct_prop_black <- bcc_ct_n_black / bcc_ct_n
# Estimated umber of new BCC and cSCC patients per year provided by the
#  American Cancer Society
nmsc_yr <- 3315554
# proportion of NMSC claimants who are Black from Lukowiak, et al.:
nmsc_prop_black <- 0.0413
# proportion of BCC diagnoses among Black NMSC claimants from Lukowiak, et al.:
prop_black_bcc <- 23315 / 39385
# Estimate number of Black BCC patients diagnosed per year
bcc_n_black_yr <- nmsc_yr * nmsc_prop_black * prop_black_bcc
# calculate est Black BCC patients diagnosed per year that are represented by
#   clinical trial participants
bcc_n_rep_black_yr <- nmsc_yr * bcc_ct_prop_black * prop_black_bcc
# calculate number of unrepresented BCC patients diagnosed in 2024
bcc_n_unrep_black_yr <- bcc_n_black_yr - bcc_n_rep_black_yr

# calculate proportion of cSCC clinical trial participants who are Black
cscc_ct_prop_black <- cscc_ct_n_black / cscc_ct_n
# proportion of cSCC diagnoses among Black NMSC claimants from Lukowiak, et al.:
prop_black_cscc <- 16070 / 39385
# Estimate number of Black cSCC patients diagnosed per year
cscc_n_black_yr <- nmsc_yr * nmsc_prop_black * prop_black_cscc
# calculate est Black cSCC patients diagnosed per year that are represented by
#   clinical trial participants
cscc_n_rep_black_yr <- nmsc_yr * cscc_ct_prop_black * prop_black_cscc
# calculate number of unrepresented cSCC patients diagnosed in 2024
cscc_n_unrep_black_yr <- cscc_n_black_yr - cscc_n_rep_black_yr

# proportion of Black patients unrepresented
bcc_n_unrep_black_yr / bcc_n_black_yr
cscc_n_unrep_black_yr / cscc_n_black_yr


# BCC demographics bar plot -----

# load windows fonts for bar graph labels (optional)
# loadfonts(device = "win")

# proportion of US BCC patients who are black
bcc_claim_prop_black <- bcc_claim_n_black / bcc_claim_n
# calculate proportions of white and black BCC clinical trial participants
bcc_ct_n_white <- sum(bccCtDemo_df$white_participants, na.rm = TRUE)
bcc_ct_prop_white <- bcc_ct_n_white / bcc_ct_n
# calculate proportions of white and black BCC claimants
bcc_claim_n_white <- 556716
bcc_claim_prop_white <- bcc_claim_n_white / bcc_claim_n

# barplot of % white and black participants in BCC clinical trials vs claims
bar_pop <- c(
  rep("Clinical trial participants", 2),
  rep( "Insurance claimants", 2)
)
bar_race <- rep(c("Black", "White"), 2)
bcc_prop <- c(
  bcc_ct_prop_black,
  bcc_ct_prop_white,
  bcc_claim_prop_black,
  bcc_claim_prop_white
)
bcc_demoBar <- data.frame(
  bar_pop,
  bar_race,
  bcc_prop
)

bccplot <- ggplot(
  bcc_demoBar,
  aes(
    fill = bar_race,
    y = bcc_prop,
    x = bar_pop
  )
) +
  geom_bar(position = "dodge", stat = "identity") +
  labs(
    title = str_wrap(
      "Race of BCC clinical trial participants vs. insurance claimants with BCC in the United States",
      width = 50
    ),
    fill = "Race",
    y = "Percent",
    x = NULL
  ) +
  scale_y_continuous(labels = scales::percent) +
  theme(
    text = element_text(family = "Times New Roman"),
    axis.text.x = element_text(size = 11),
    axis.title.y = element_text(size = 11),
    title = element_text(size = 11),
    plot.title = element_text(
      hjust = 0,
      face = "italic",
      margin = margin(b = 20) 
    )
  )

print(bccplot)


# cSCC demographics bar plot -----

# proportion of US cSCC patients who are black
cscc_claim_prop_black <- cscc_claim_n_black / cscc_claim_n
# calculate proportions of white and black BCC clinical trial participants
cscc_ct_n_white <- sum(csccCtDemo_df$white_participants, na.rm = TRUE)
cscc_ct_prop_white <- cscc_ct_n_white / cscc_ct_n
# calculate proportions of white and black BCC claimants
cscc_claim_n_white <- 330285
cscc_claim_prop_white <- cscc_claim_n_white / cscc_claim_n

# barplot of % white and black participants in BCC clinical trials vs claims
cscc_prop <- c(
  cscc_ct_prop_black,
  cscc_ct_prop_white,
  cscc_claim_prop_black,
  cscc_claim_prop_white
)
cscc_demoBar <- data.frame(bar_pop, bar_race, cscc_prop)

csccplot <- ggplot(
  cscc_demoBar,
  aes(
    fill = bar_race,
    y = cscc_prop,
    x = bar_pop
  )
) +
  geom_bar(position = "dodge", stat = "identity") +
  labs(
    title = str_wrap(
      "Race of cSCC clinical trial participants vs. insurance claimants with cSCC in the United States",
      width = 50
    ),
    fill = "Race",
    y = "Percent",
    x = NULL
  ) +
  scale_y_continuous(labels = scales::percent) +
  theme(
    text = element_text(family = "Times New Roman"),
    axis.text.x = element_text(size = 11),
    axis.title.y = element_text(size = 11),
    title = element_text(size = 11),
    plot.title = element_text(
      hjust = 0,
      face = "italic",
      margin = margin(b = 20)
    )
  )

print(csccplot)
