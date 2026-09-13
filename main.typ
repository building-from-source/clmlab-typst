#import "typst-article-template/lib.typ": flex-caption, ubo
#import "@preview/wordometer:0.1.5": total-words, word-count-of

#let chapter-word-counts(body) = {
  let children = if "children" in body.fields() { body.children } else { (body,) }
  let groups = ()
  let chapter = ()

  for child in children {
    if child.func() == heading and child.depth == 1 {
      if chapter.len() > 0 {
        groups.push(chapter)
      }
      chapter = (child,)
    } else {
      chapter.push(child)
    }
  }
  if chapter.len() > 0 {
    groups.push(chapter)
  }

  groups.fold([], (result, group) => {
    let chapter-content = group.fold([], (content, child) => content + child)
    if group.first().func() != heading or group.first().depth != 1 {
      result + chapter-content
    } else {
      let stats = word-count-of(chapter-content, exclude: <word-count-display>)
      let word-label = if stats.words == 1 { "word" } else { "words" }
      let chapter-heading = group.first()
      let fields = chapter-heading.fields()
      let _ = fields.remove("body")
      let annotated-heading = heading(
        [
          #chapter-heading.body
          #h(0.6em)
          #text(size: 0.55em, weight: "regular", fill: gray)[
            (#stats.words #word-label) <word-count-display>
          ]
        ],
        ..fields,
      )
      let chapter-body = group.slice(1).fold([], (content, child) => content + child)
      result + annotated-heading + chapter-body
    }
  })
}

#let with-word-counts(body) = {
  let body-word-count = word-count-of(body, exclude: <word-count-display>)
  set page(footer: context {
    grid(
      columns: (1fr, 1fr),
      [#total-words words <word-count-display>], align(right, counter(page).display("1")),
    )
  })
  state("wordometer").update(body-word-count)
  chapter-word-counts(body)
}

#let screenshot(path, caption) = figure(
  image(path, width: 100%),
  caption: caption,
  placement: none,
)

#let appendix = [
  #include "appendix.typ"
]

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
  bibliography-file: none,
)

#[
#show: with-word-counts

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



= Background

- Ordinal outcomes
  - Likert scales
  - HCI
- CL(M)Ms
  - Assumptions
  - Inputs/Outputs



= Related Work

@liddell2018analyzing
- Liddell and Kruschke
- looked at articels in the Journal of personality and Social Psychology, Psychological Science, and the Journal of Experimantal Psychology: General (psychological research) that mentioned "Likert"
  - found that every (100%) article that analyzed ordinal data used metric models
  - doing so can lead to Type I and Type II errors, inversion of effects
- they advocate the use of ordinal models, such as ordered-probit models, which explicitly account for the ordered categorical nature of the response

Syiem et. al make the case that ...@Victor_Syiem_2026
- ordinal measures are often used in HCI research, but there is no consensus on how to analyze them
- they looked at recent HCI papers and how they analyzed their ordinal outcomes
- they propose/defend/... the use of CL(M)Ms for analyzing ordinal outcomes in HCI research
- they perform two case studies on published open-source datasets

// @taylor2023rating
// - Taylor

@sarma2026adapting
- Sarma
- posits that one reason for low adoption of ordinal regression models in HCI research may be the difficulty of visualizing the outputs of these models + in communicating the results in an intuitive manner
- they propose modified Complementary Cumulative Distribution Function (CCDF) plots to visualize the outputs of ordinal regression models
- CCDF gives the probability of an item being rated strictly greater than a given category
- their modified CCDF gives the probability of an item being rated at least as high as a given category (y=0.5 -> median rating)

= Related Software
// Overview of existing software, their limitations / problems

- observations from using Jasp and Jamovi to specify ordinal regression models
- focus on how users select a model, check variable types and level orders, and specify model terms
- these observations informed the design goals and workflow of our tool, described in the next chapter

== Jasp

- is an open-source statistics program
- GUI-based, no programming required
- can be used to analyze data with ordinal outcomes

@fig:jasp-ordinal-regression-error
- in the figure, Variable type of the variable "apply" (ordinal) is set to "Nominal" by Jasp, despite the fact that it is an ordinal variable. As a consequence, Jasp shows an error message when trying to fit an ordinal regression model.

@fig:jasp-hidden-ordinal-regression
- in jasp a model is continously updated when the user changes the model specificatiion, which can lead to error messages being shown to the user while the model is still in the process of being specified
- ordinal logistic regression is located under the "Other" model family, which is not intuitive for users who are looking for a model for ordinal outcomes

@fig:jasp-automatic-interaction-terms
- Jasp adds interaction terms to the model automatically
- the ability to remove them is located under the "Model" tab, a seperate place from where the user specifies the parameters of the model
- (while this can make sense as a default, as not having interactions would mean that we assume that there is additivity on the model's link scale, it is not necessarily intuitive for users who are not familiar with this type of statistical analysis)

#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    image("assets/jasp-nominal-outcome.png", width: 100%),
    image("assets/jasp-ordinal-regression-error.png", width: 100%),
  ),
  caption: [Variable type of the variable "apply" (ordinal) is set to "Nominal" by Jasp.],
  placement: none,
) <fig:jasp-ordinal-regression-error>

#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    image("assets/jasp-incompatible-bernoulli-model.png", width: 100%),
    image("assets/jasp-hidden-ordinal-regression.png", width: 100%),
  ),
  caption: [Jasp shows a red warning during model specification due to the currently selected model being unfit for the data. Ordinal Logistic Regression is located under the "Other" model family.],
  placement: none,
) <fig:jasp-hidden-ordinal-regression>

#screenshot("assets/jasp-automatic-interaction-terms.png")[
  Jasp adds interaction terms to the model automatically. The ability to remove them is located under the "Model" tab.
] <fig:jasp-automatic-interaction-terms>

== Jamovi

@fig:jamovi-ordinal-regression-menu
- ordinal logistic regression is directly accessible through the "Ordinal Outcomes" option in the "Regression" menu
- naming the option after the outcome type helps users identify the appropriate model for their data

@fig:jamovi-default-level-order
- Jamovi fits an ordinal regression model even though the outcome variable "apply" is set to "Nominal"
- the default level order is "somewhat likely", "unlikely", "very likely", which does not match the intended order of the responses
- the order is reported in a note below the model fit measures, but users are not prompted to confirm it before fitting the model, so an incorrect order may go unnoticed

#screenshot("assets/jamovi-ordinal-regression-menu.png")[
  Jamovi lets the user select the type of regression model to fit directly, including models for ordinal outcomes.
] <fig:jamovi-ordinal-regression-menu>

#screenshot("assets/jamovi-default-level-order.png")[
  If the user selects "Ordinal Outcome" for the regression model, Jamovi fits a model with the default order, without requiring user confirmation or input.
] <fig:jamovi-default-level-order>



= Design and Implementation
// Description of the design and implementation of the website
Target audience:
- HCI researchers
  - with little to no statistical background, but some experience with statistical analysis
  - want to analyze their data using CLM(M) without having to learn R or Python
  - do not know what to report, and how (text, visualizations, ...)

Design goals for our tool:
- our tool should make important defaults visible and editable before fitting
  - users should be prompted to check a variable's type and, for ordinal variables, reorder the levels if needed when adding it to the model
  - motivated by the observed problems with default variable types and level orders (@fig:jasp-ordinal-regression-error, @fig:jamovi-default-level-order)
- our tool should guide model selection through the outcome type
  - the regression family should be derived from the chosen outcome type, and this choice should be explained before fitting
  - aims to make model selection accessible to users who may not know which regression family is appropriate for their data
  - motivated by the observations about finding an appropriate model and the usefulness of outcome-based labels (@fig:jasp-hidden-ordinal-regression, @fig:jamovi-ordinal-regression-menu)
- our tool should make adding and removing interactions an intuitive part of model specification
  - users should be able to review and adjust interactions alongside the other model terms
  - motivated by the observation about interaction controls being separated from the main specification flow (@fig:jasp-automatic-interaction-terms)
- our tool should separate model specification from fitting
  - users should be guided through the specification steps and explicitly confirm before fitting, so fitting is a deliberate action
  - motivated by the observation about error messages appearing during incomplete model specification (@fig:jasp-hidden-ordinal-regression)
  - also intended to discourage repeated model changes aimed at obtaining significant results (p-hacking)
- our tool should help users understand model specification and results
  - explanations and tool-tips should be available where users select model terms or interpret the output
  - statistical terms, reported values and plots should be explained in accessible language
  - motivated by the target audience having limited statistical background and potentially being unfamiliar with CLM(M)

== General Workflow for Model Creation
- intitial idea:
  - fit models with predictors treated as continous instead of as ordinal, treat as continous if AIC improves, otherwise treat as ordinal
  - was rejected, because it (un-intuitively) makes interpretation of the model more difficult
- minimize friction, while making sure that results are accurate and interpretable
  - information boxes and tool-tips explain statistical terms during model specification and when interpreting results

@fig:clmm-tool-start-analysis
- users can upload a CSV file to start an analysis or reopen a past analysis
- after uploading a CSV file, an LLM profiles the variables before the first step of model specification
  - a loading screen with a spinner is shown during profiling

#screenshot("assets/clmm-tool-start-analysis.png")[
  Landing page with buttons to upload a CSV file or reopen a past analysis.
] <fig:clmm-tool-start-analysis>

@fig:clmm-tool-outcome-selection
- the workflow guides users through selecting an outcome variable, fixed effects, and optional random effects and interactions
- the first step is to choose an outcome variable
  - an information box explains what an outcome variable is
  - a filter and sorting options help users find the variable they want to use
- the model formula initially shows placeholders and is updated as users specify the model

#screenshot("assets/clmm-tool-outcome-selection.png")[
  First step of model specification, with the available variables on the left and a drop zone for the outcome and the model formula on the right.
] <fig:clmm-tool-outcome-selection>

@fig:clmm-tool-variable-type-dialog
- when a variable is dragged into the drop zone (outcome, predictor or random effect), its settings open automatically
  - prompts users to check the variable type and, for ordinal variables, the order of the levels before proceeding
  - users can override the LLM-chosen variable type and level order

#screenshot("assets/clmm-tool-variable-type-dialog.png")[
  Variable settings for the outcome "apply", showing its ordinal type and editable level order.
] <fig:clmm-tool-variable-type-dialog>

@fig:clmm-tool-regression-family-dialog
- after model specification, a dialog shows the inferred regression family and explains why it was chosen
- users can confirm to fit the model or go back and change the outcome's variable type
- fitting only happens after confirmation, with no automatic refitting after each change

#screenshot("assets/clmm-tool-regression-family-dialog.png")[
  Confirmation dialog explaining the choice of a CLM based on the ordinal outcome variable.
] <fig:clmm-tool-regression-family-dialog>

== Results Page

- information boxes and tool-tips explain statistical terms, reported values and how to read the plots

@fig:clmm-tool-model-summary
- the "Summary" page is split into two parts
  - left: model summary including info from R output (AIC, terms, estimates, standard errors, z values and p-values) in a formatted table
  - can switch between table and visual representation of the model summary
  - right: high level model summary (one brief paragraph, what was the model that was fitted, what are the main effects)
  - "Health Details" below the text summary, with info on max gradient, proportional odds etc.

#screenshot("assets/clmm-tool-model-summary.png")[
  Summary page with model output on the left and a text summary and health details on the right.
] <fig:clmm-tool-model-summary>

@fig:clmm-tool-fixed-effects
- the "Fixed Effects" page provides plots for each fixed effect
  - for categorical predictors, the relative view shows differences in predicted probabilities for each response category compared to the reference level (i.e. the first level of the factor)
  - users can show bootstrap 95% confidence intervals as error bars

#screenshot("assets/clmm-tool-fixed-effects.png")[
  Fixed Effects page showing differences in predicted probabilities for "pared", comparing level 1 to the reference level 0.
] <fig:clmm-tool-fixed-effects>

== AI Chatbot

@fig:clmm-tool-outcome-selection
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

= User Study
// Description of the user study

== Pilot Study
// Description of the pilot study

- goal of the pilot study was to iron out any obvious issues with the tool and to get feedback from users on the usability of the tool
- one learning: users managed to fit the correct model, even if they struggled to understand the output
  - prompted us to focus on the output and how to make it more understandable for users in the user study

== User Study

- for the user study we decided to compare outputs / results using our tool and as what someone would get if they worked with LLM-assistance
- rather than making the participants in the LLM-assistance group use an LLM to generate a script that they would then run in R, we decided to provide them with the output of the model and ask them to interpret it (i.e., write a paragraph about what the model output means in the context of the study) as we did not want to measure their ability to use an LLM or the LLM's ability to generate a script, but rather the ability of the participants to interpret the model output that a researcher would get when using an LLM to assist them in their analysis
- the results page of our tool was created to be similar to the actual tool, but enhanced with "LLM-assisted" interpretations that take the study contetext into account (wizard of oz approach), hard-coded, not different for each participant, but the same for all participants in the LLM-assisted group
- between groups design
- two scenarios each
  - one "simple" (no random effects, no interactions)
  - one "complex" (two random intercepts, interaction)
- subjects were randomly assigned to one of the two groups (tool vs. LLM-assisted interpretations)
- make them answer a question about the model output / write an interpretation  (TOOD: clarify)
- subjects: bachelor's students enrolled in computer science/cyber security program, partake in "Usable Security and Privacy" course, got taught basics of regression analysis

== Simple Scenario

#screenshot("assets/user-study-simple-fixed-effects.png")[
  // Write caption here.
]

#screenshot("assets/user-study-simple-predicted-probabilities.png")[
  // Write caption here.
]

#screenshot("assets/user-study-simple-average-marginal-effects.png")[
  // Write caption here.
]

== Complex Scenario

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



// = Results
// Results of the user study



= Limitations
- Study scope
  - Participants interpreted pre-fitted models -> study does not evaluate the full workflow of creating and fitting models with LLM assistance / the tool
- Participants
  - Students with basic regression training may differ from researchers conducting their own analyses
- Scenarios
  - Two scenarios cover a limited range of analysis tasks.
- Wizard of Oz setup
  - Prepared interpretations may not reflect the quality or variability of responses generated by a live LLM (in our tool)

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
]

#pagebreak()
#bibliography(
  path("bibliography.bib"),
  style: path("typst-article-template/assets/din-1505-2-alphanumeric.csl"),
)

#pagebreak()
#appendix
