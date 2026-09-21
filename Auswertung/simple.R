library(ordinal)

ologit_data <- read.csv("ologit_data.csv")
ologit_data$apply <- ordered(
  ologit_data$apply,
  levels = c("unlikely", "somewhat likely", "very likely")
)

simple_model <- clm(
  apply ~ pared + public + gpa,
  data = ologit_data,
  link = "logit"
)

summary(simple_model)
exp(simple_model$beta)
