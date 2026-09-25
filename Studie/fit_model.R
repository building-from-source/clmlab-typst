# Complex condition: CLMM with crossed random effects + an interaction.
# Data: a 400-row subsample of the InstEval dataset (lme4), the standard
# textbook example of crossed random effects (student x instructor).
# See ../derive_subsample.R for how data/insteval_subsample.csv was drawn.

library(ordinal)

df <- read.csv("data/insteval_subsample.csv")
df$student_id <- factor(df$student_id)
df$instructor_id <- factor(df$instructor_id)
df$service <- factor(df$service)
df$studage_group <- factor(df$studage_group, levels = c("early", "late"))
df$rating <- factor(df$rating, levels = 1:5, ordered = TRUE)

fit <- clmm(rating ~ service * studage_group + (1 | student_id) + (1 | instructor_id),
            data = df)

summary(fit)
exp(coef(fit))
VarCorr(fit)
