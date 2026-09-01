#import "typst-article-template/lib.typ": flex-caption, ubo
#import "@preview/wordometer:0.1.5": total-words, word-count

#let screenshot(path, caption) = figure(
  image(path, width: 100%),
  caption: caption,
  placement: none,
)

#show: ubo.with(
  title: "CLM(M)-tool",
  author: "Julian Steffen",
  matrikelno: "3421717",
  first-examiner: "Dr. Christian Tiefenau",
  // first-examiner-affiliation: [University of Bonn], // This is optional, defaults to localized "University of Bonn" for both examiners
  second-examiner: "/",
  second-examiner-affiliation: [],
  supervisor: "Florin Martius",
  thesis-kind: "lab",
  // abstract: abstract, // This is optional
  // acknowledgement: acknowledgement, // This is optional
  print-style: "single", // "single" or "double", defaults to "single". Helpful for double-sided printing.
  language: "en", // This is optional, defaults to "en"
  bibliography-file: path("bibliography.bib"),
)

#show: word-count.with(exclude: <word-count-display>)

= Introduction
// Problem statement, motivation, context
- HCI researchers often have ordinal outcomes in their studies (e.g., Likert scales) and need to analyze them statistically
- treating those outcomes as different types of data simplifies the analysis, but can lead to incorrect conclusions
- Cumulative Link (Mixed) Models (CLM(M)) is a statistical model that can be used to analyze ordinal outcomes, but it is not (yet) widely used in HCI research
- software either not usable (Jacobi, ...) or not accessible (R, Python, ...), which makes it hard for HCI researchers to use CLM(M) in their studies
- The goal of this Lab is to design and implement a web-based tool that allows HCI researchers to easily use CLM(M) in their studies, and to evaluate the tool through a user study

- Also:
- using the typical package used for CLM(M) in R (ordinal) can lead to incorrect conclusions as the output can be misleading if the model includes interactions, leading to further complicaions

// ```r
// # Add R code here.
// ```

#align(right)[
  *Draft word count:* #total-words
] <word-count-display>

= Related Work

Syiem et. al make the case that ...@Victor_Syiem_2026



= Related Software
// Overview of existing software, their limitations / problems

== Jasp

#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    image("assets/jasp-nominal-outcome.png", width: 100%),
    image("assets/jasp-ordinal-regression-error.png", width: 100%),
  ),
  caption: [Variable type of the variable "apply" is set to "Nominal" by Jasp, despite the fact that it is an ordinal variable. As a consequence, Jasp shows an error message when trying to fit an ordinal regression model.],
  placement: none,
)

#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    image("assets/jasp-incompatible-bernoulli-model.png", width: 100%),
    image("assets/jasp-hidden-ordinal-regression.png", width: 100%),
  ),
  caption: [Jasp shows a red warning during model specification due to the currently selected model being unfit for the data. Ordinal Logistic Regression is hidden behind the "Other" model family.],
  placement: none,
)

#screenshot("assets/jasp-automatic-interaction-terms.png")[
  Jasp adds interaction terms to the model automatically and hides the ability to remove them in a sub-menu.
]

== Jamovi

#screenshot("assets/jamovi-ordinal-regression-menu.png")[
  Jamovi lets the user select the type of regression model to fit directly, including models for ordinal outcomes.
]

#screenshot("assets/jamovi-default-level-order.png")[
  If the user selects "Ordinal Outcome" for the regression model, Jamovi fits a model with the default order, without requiring user confirmation or input.
]

#align(right)[
  *Draft word count:* #total-words
] <word-count-display>

= Design and Implementation
// Description of the design and implementation of the website
Target audience:
- HCI researchers
  - with little to no statistical background, but some experience with statistical analysis
  - want to analyze their data using CLM(M) without having to learn R or Python
  - do not know what to report, and how (text, visualizations, ...)

== General Workflow for Model Creation
- intitial idea:
  - fit models with predictors treated as continous instead of as ordinal, treat as continous if AIC improves, otherwise treat as ordinal
  - was rejected, because it (un-intuitively) makes interpretation of the model more difficult
- minimize friction, while making sure that results are accurate and interpretable
  - profiling (-> user can overwrite the LLM-chosen variable types and for ordinal variables, the user can override the order of the levels)
  - force user to check important info (i.e. variable types) when they pick it as an outcome variable / predictor / random effect by force opening a window with the variable type and the order of the levels (for ordinal variables) when dragging them into a model slot
  - no p-hacking (!) -> no constant updating
  - tool-tips for everything

== Results Page

- model summary including info from R output (coefficients, p-values, AIC) and additional info that is relevant for HCI researchers in a formatted table
  - can switch between table and visual representation of the model summary
- high level model summary (one brief paragraph, what was the model that was fitted, what are the main effects)
- "Health" Details
  - max gradient, proportional odds etc.

== AI Chatbot

- optional, bottom right, but open by default
- context aware
  - dataset's filename and dimensions
  - the chosen outcome, predictors, interactions and random effects
  - user-confirmed ordering of ordinal categories
  - the inferred regression family
  - after model fitting: info visible in the model summary (coefficients, p-values, AIC, ...), and the model's health details
- explanations only, can't change the model, run new models, or change the data
- currently stateless (can't remember previous messages)
- no raw observations/dataset rows are sent to the LLM provider (OpenAI)
- GPT 5.4 mini

#screenshot("assets/clmm-tool-start-analysis.png")[
  // Write caption here.
]

#screenshot("assets/clmm-tool-outcome-selection.png")[
  // Write caption here.
]

#screenshot("assets/clmm-tool-variable-type-dialog.png")[
  // Write caption here.
]

#screenshot("assets/clmm-tool-regression-family-dialog.png")[
  // Write caption here.
]

#screenshot("assets/clmm-tool-model-summary.png")[
  // Write caption here.
]

#screenshot("assets/clmm-tool-fixed-effects.png")[
  // Write caption here.
]

#align(right)[
  *Draft word count:* #total-words
] <word-count-display>

= User Study
// Description of the user study

== Pilot Study
// Description of the pilot study

- goal of the pilot study was to iron out any obvious issues with the tool and to get feedback from users on the usability of the tool
- one learning: users managed to fit the correct model, even if they struggled to understand the output
  - prompted us to focus on the output and how to make it more understandable for users in the user study

== User Study

- for the user study we decided to compare outputs / results using our tool and as what someone would get if they worked with LLM-assistance
- the results page of our tool was created to be similar to the actual tool, but enhanced with "LLM-assisted" interpretations that take the study contetext into account (wizard of oz approach)
- between groups design
- two scenarios each
  - one "simple" (no random effects, no interactions)
  - one "complex" (two random intercepts, interaction)
- subjects were randomly assigned to one of the two groups (tool vs. LLM-assisted interpretations)
- make them answer a question about the model output / write an interpretation  (TOOD: clarify)
- subjects: bachelor's students enrolled in computer science/cyber security program, partake in "Usable Security and Privacy" course, got taught basics of regression analysis

== 1

#screenshot("assets/user-study-simple-fixed-effects.png")[
  // Write caption here.
]

#screenshot("assets/user-study-simple-predicted-probabilities.png")[
  // Write caption here.
]

#screenshot("assets/user-study-simple-average-marginal-effects.png")[
  // Write caption here.
]

== 2

#screenshot("assets/user-study-complex-model-summary.png")[
  // Write caption here.
]

#screenshot("assets/user-study-complex-simple-effects.png")[
  // Write caption here.
]

#screenshot("assets/user-study-complex-predicted-probabilities.png")[
  // Write caption here.
]

#screenshot("assets/user-study-complex-effect-contrasts.png")[
  // Write caption here.
]

#align(right)[
  *Draft word count:* #total-words
] <word-count-display>

= Results
// Results of the user study

#align(right)[
  *Draft word count:* #total-words
] <word-count-display>

= Future Work
// Where do we go next

- possible features to add to a final version of the tool:
  - wide to long format conversion
    - upload data (qualtrix format?)
    - automatic conversion to long format
  - support for more complex models (e.g., different kinds of random effects)
    - currently supports random intercepts `(1 | x)` + crossed random effects `(1 | x) + (1 | y)`, but not random slopes or nested random effects
    - should support random slopes `(x | y)` and nested random
  - generalize tool to support other types of models
  - Contextualized LLM-assisted interpretations based on description of the study and the model output (#sym.arrow higher value than just lists of coefficients and p-values, more relevant)
    - as in user study
  - check all assumptions of the model and provide feedback to the user if any assumptions are violated
  - assisted "fix this model" feature, i.e. if variables are co-linear, or if the model is not converging, provide suggestions to the user on how to fix the model

#align(right)[
  *Draft word count:* #total-words
] <word-count-display>
