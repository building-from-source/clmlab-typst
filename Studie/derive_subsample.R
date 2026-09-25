# Provenance script: how data/insteval_subsample.csv was derived from the
# full InstEval dataset (lme4). Not needed to reproduce the model fit
# (fit_model.R reads the saved CSV directly) -- this is here so the sampling
# procedure is auditable.

library(ordinal)

data(InstEval, package = "lme4")
d <- InstEval
d$studage_group <- factor(ifelse(d$studage %in% c("2", "4"), "early", "late"),
                           levels = c("early", "late"))
d$rating <- factor(d$y, levels = 1:5, ordered = TRUE)

set.seed(23)
insts <- sample(levels(d$d), 30)
sub <- d[d$d %in% insts, ]
stud_counts <- table(droplevels(sub$s))
keep_studs <- names(stud_counts[stud_counts >= 2])
sub <- sub[sub$s %in% keep_studs, ]
if (nrow(sub) > 400) sub <- sub[sample(nrow(sub), 400), ]  # continues the RNG stream, no reseed
sub$s <- droplevels(sub$s)
sub$d <- droplevels(sub$d)

out <- sub[, c("s", "d", "service", "studage_group", "rating")]
names(out) <- c("student_id", "instructor_id", "service", "studage_group", "rating")
write.csv(out, "data/insteval_subsample.csv", row.names = FALSE)
