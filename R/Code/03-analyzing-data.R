# Reproducible Research Fundamentals 
# 03. Data Analysis

# Libraries -----
 library(haven)
 library(dplyr)
 library(modelsummary)
 library(stargazer)
 library(ggplot2)
 library(tidyr)
library(ggtext)


# Load data -----
#household level data
data_path <- "/Users/vhpf/Library/CloudStorage/OneDrive-Personal/ProjetosCarreira/RA_DIME/dc_sept2025/Transparent and Credible Analytics/Course Materials/DataWork/Data"
hh_data   <- read_dta(file.path(data_path, "Final/TZA_CCT_analysis.dta"))

# secondary data 
secondary_data <- read_dta(file.path(data_path, "Final/TZA_amenity_analysis.dta")) %>%
    mutate(district = as_factor(district))

# Exercise 1 and 2: Create graph of area by district -----

# Bar graph by treatment for all districts
# Ensure treatment is a factor for proper labeling
hh_data_plot <- hh_data %>%
    mutate(treatment = factor(treatment, labels = c("Control", "Treatment")), 
           district = as_factor(district))

# Get what we want
hh_data_plot <- hh_data_plot %>% 
  subset(select = c(district, area_acre_w, treatment))
hh_data_plot <- hh_data_plot %>%
  group_by(district, treatment) %>%
  summarise(mean_area = mean(area_acre_w, na.rm = TRUE)) %>%
  ungroup()
hh_data_plot

# Create the bar plot
# Create the bar plot
plot <- ggplot(hh_data_plot, aes(x = district, y = mean_area, fill = treatment)) +
  geom_bar(stat = "identity", position='dodge', width=0.5) +
  scale_fill_manual(values = c("Control" = "#1a659e", "Treatment" = "#ff6700")) +
  geom_hline(yintercept = 0, 
             color = "black", linetype = "solid", size = 0.75) +  
  theme_minimal() +
  labs(title = "Average Area Farmed by District",
       subtitle = "By <span style='color:#1a659e;'>Control</span> and <span style='color:#ff6700;'>Treatment</span> Groups",
       x = "", 
       y = "Area Farmed (in acres)") +
  theme(panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(color = "lightgrey", linetype = "solid"),
        plot.subtitle = element_markdown(),
        legend.position = 'none',
        axis.text.x = element_text(angle = 0, hjust = 0.5, vjust = 1, size = 12)) +
  scale_y_continuous(limits = c(0, 2), breaks = seq(0, 2, by = 0.5))
  
plot  
       
# Exercise 3: Create a density plot of non-food consumption -----
       
# Calculate mean non-food consumption for female and male-headed households
mean_female <- hh_data %>% 
   filter(female_head == 1) %>% 
   summarise(mean = mean(nonfood_cons_usd_w, na.rm = TRUE)) %>% 
   pull(mean)

mean_male <- hh_data %>% 
   filter(female_head == 0) %>% 
   summarise(mean = mean(nonfood_cons_usd_w, na.rm = TRUE)) %>% 
   pull(mean)

       

# Exercise 4: Summary statistics ----

# Create summary statistics by district and export to CSV





hh_balance <- hh_data %>% 
  subset(select = c(hhid, area_acre, food_cons_usd, nonfood_cons_usd, sick, treatment))
hh_balance <- hh_balance %>%
  select(`Food Consumption (USD)` = food_cons_usd,
         `Non-food Consumption (USD)` = nonfood_cons_usd,
         `Days Sick` = sick,
         `Area (in Acres)` = area_acre,
         `Treatment` = treatment)

# Exercise 5: Balance table ----
balance_table <- datasummary_balance(
  `Area (in Acres)` + `Food Consumption (USD)` + `Non-food Consumption (USD)` + `Days Sick` ~ `Treatment`,
    data = hh_balance,
    stars = TRUE,
    title = "Balance by Treatment Status",
    note = "Includes HHS with observations for baseline and endline",
    out = 'data.frame'
)

write.csv(balance_table,
          "/Users/vhpf/Library/CloudStorage/OneDrive-Personal/ProjetosCarreira/RA_DIME/dc_sept2025/rrf2025_vhpf/R/Outputs/balance_table.csv",
          row.names = FALSE)
# Exercise 6: Regressions ----

# Model 1: Food consumption regressed on treatment
model1 <- lm(food_cons_usd ~ treatment, data = hh_data)

# Model 2: Add controls (crop_damage, drought_flood)
model2 <- lm(food_cons_usd ~ treatment + crop_damage + drought_flood, data = hh_data)

# Model 3: Add FE by district
model3 <- lm(food_cons_usd ~ treatment + crop_damage + drought_flood + factor(district), data = hh_data)

models <- list("Model 1" = model1,
               "Model 2" = model2,
               "Model 3" = model3)
# Create regression table using stargazer
stargazer(
  models,
  title = "Food Consumption Effects",
  keep = c("treatment", "crop_damage", "drought_flood"),
  covariate.labels = c("Treatment",
                       "Crop Damage",
                       "Drought/Flood"),
  dep.var.labels = c("Food Consumption (USD)"),
  dep.var.caption = "",
  add.lines = list(c("District FE", "No", "No", "Yes")),
  header = FALSE,
  keep.stat = c("n", "adj.rsq"),
  notes = "Standard errors in parentheses",
  type = "latex"
)

# Exercise 7: Combining two plots ----

