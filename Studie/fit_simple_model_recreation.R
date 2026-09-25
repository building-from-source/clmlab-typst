# Simple condition: CLM with three predictors
# Data: 400 observations from ologit_data.csv, relating application
# likelihood to parental education, institution type, and GPA.

library(ordinal)

df <- read.csv("data/ologit_data.csv")
df$apply <- factor(df$apply,
                   levels = c("unlikely", "somewhat likely", "very likely"),
                   ordered = TRUE)

fit <- clm(apply ~ pared + public + gpa, data = df, link = "logit")

summary(fit)
