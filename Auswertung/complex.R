library(ordinal)

insteval_subsample <- read.csv("insteval_subsample.csv")
insteval_subsample$rating <- ordered(insteval_subsample$rating)
insteval_subsample$studage_group <- factor(
  insteval_subsample$studage_group,
  levels = c("early", "late")
)

complex_model <- clmm(
  rating ~ service * studage_group +
    (1 | student_id) + (1 | instructor_id),
  data = insteval_subsample,
  link = "logit",
  Hess = TRUE
)

summary(complex_model)
exp(complex_model$beta)

late_terms <- c("service", "service:studage_grouplate")
late_estimate <- sum(complex_model$beta[late_terms])
late_se <- sqrt(sum(vcov(complex_model)[late_terms, late_terms]))

c(
  late_service_estimate = late_estimate,
  late_service_odds_ratio = exp(late_estimate),
  late_service_p_value = 2 * pnorm(abs(late_estimate / late_se), lower.tail = FALSE)
)
