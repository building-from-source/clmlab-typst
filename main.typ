#import "typst-article-template/lib.typ": flex-caption, ubo
#import "@preview/wordometer:0.1.5": total-words, word-count-of
#import "screenshot.typ": screenshot
#import "design-goals.typ": design-goals

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

  Likert items are survey items commonly used in HCI research @Victor_Syiem_2026.
  They can use different sets of response categories, for example "strongly disagree", "disagree", "neutral", "agree", and "strongly agree".
  These responses are called ordinal outcomes, as they are categorical data with a natural order.
  The order of these categories is important, but the distance between them is not necessarily equal, meaning that treating them as equally spaced numerical values may lead to misleading conclusions @liddell2018analyzing.

  Cumulative Link Models (CLMs) are statistical models that can be used to analyze these ordinal outcomes.
  They account for the ordered nature of the data without assuming equal distances between categories @christensen2018cumulative.
  Cumulative Link Mixed Models (CLMMs) extend CLMs with random effects to account for dependence in grouped or repeated observations.
  For example, a random intercept for each participant allows their baseline tendency to give higher or lower ratings to vary @taylor2023rating.

  The R package "ordinal" provides functions to fit both CLMs and CLMMs @ordinal.
  The outcome variable needs to be an ordered factor, while the independent variables can be factors, ordered factors, or interval/ratio variables @mangiafico2016clm.



  = Related Work

  Working with ordinal outcomes requires attention both to how the data are analyzed and to how the results are communicated.

  Liddell and Kruschke examined articles in the 2016 volumes of the Journal of Personality and Social Psychology, Psychological Science, and the Journal of Experimental Psychology: General that mentioned "Likert" @liddell2018analyzing.
  All 68 eligible articles in their review used metric models to analyze ordinal outcomes.
  The authors also demonstrate that analyzing ordinal data with metric models can lead to Type I and Type II errors and inversions of effects.
  They advocate the use of ordinal models, such as ordered-probit models, which explicitly account for the ordered categorical nature of the response.

  Focusing on HCI research, Syiem and Velloso describe the frequent use of ordinal measures and the lack of consensus on how to analyze them @Victor_Syiem_2026.
  Their review covered a sample of 94 CHI 2024 full papers that reported user studies with statistical analyses of ordinal data, selected from a search for "questionnaire" or "Likert".
  The authors found frequent use of tests that imposed metric assumptions on ordinal data, while recording only two CLM analyses and eight CLMM analyses.
  They advocate the use of CL(M)Ms for analyzing ordinal outcomes in HCI research.
  To illustrate their application, they provide worked examples based on published open-source HCI datasets.
  These examples demonstrate how to fit and interpret a CLM for between-subject data and a CLMM for within-subject data.
  They also recommend complementing numerical and textual results with visualizations of both the observed data and the model estimates, including their uncertainty.

  // @taylor2023rating
  // - Taylor

  Sarma takes up the question of how to communicate ordinal regression results visually @sarma2026adapting.
  The paper suggests that difficulties in visualizing and communicating these results may contribute to the limited adoption of ordinal models.
  To address this, Sarma proposes modified Complementary Cumulative Distribution Function (CCDF) plots.
  Whereas a CCDF shows the probability of a response being strictly greater than a given category, the modified version shows the probability of a response being at least as high as that category.
  In the modified plot, the median rating can be read where the curve intersects $y = 0.5$.
  The paper appeared late in the development of our tool, so we did not incorporate or test these plots in the current implementation.

  Together, these works provide context for our focus on specifying ordinal models and interpreting their results.
  The next chapter examines how existing software supports model specification.

  = Related Software
  To inform the design of the tool, we examined how ordinal regression models can be specified in JASP and Jamovi from the perspective of a user with limited experience with these interfaces.
  We focused on how users select a model, check variable types and level orders, and specify model terms.
  These observations informed the design and feature goals and workflow of our tool, which are described in the next chapter.

  == JASP

  JASP is an open-source statistics program with a graphical user interface, so users can analyze data without programming.
  It can also be used to analyze data with ordinal outcomes.

  Immediately after importing the data, JASP assigns the default variable type "Nominal" to the variable "apply", even though the variable is ordinal, as shown in @fig:jasp-ordinal-regression-error.
  As a consequence, JASP shows an error message when the user tries to fit an ordinal regression model.

  Because JASP continuously updates a model while the user changes its specification, it can display a red warning before the specification is complete, as shown in @fig:jasp-incompatible-bernoulli-model.
  Ordinal logistic regression is also located under the "Other" model family, as shown in @fig:jasp-hidden-ordinal-regression, which may make the model difficult to find for users who search by outcome type.

  When specifying a model with multiple factors, JASP adds interaction terms between all factors automatically by default.
  The JASP QML guide documents this behavior through the `addInteractionsByDefault` property, whose default value is set to `true` and which adds all interactions between factors automatically @jaspqmlguide.
  The ability to remove them is located under the "Model" tab, separately from where the user specifies the parameters of the model, as shown in @fig:jasp-automatic-interaction-terms.
  However, it is not necessarily intuitive for users who are not familiar with this type of statistical analysis.
  Harrell et al. recommend choosing plausible interactions carefully because they introduce additional parameters and should represent substantive phenomena @harrell1996multivariable.

  JASP can display the R function call corresponding to an analysis, which users can copy, share and reuse within JASP to reproduce its specification @jasp_r_syntax.

  #figure(
    grid(
      columns: (1fr, 1fr),
      gutter: 1em,
      image("assets/jasp-nominal-outcome.png", width: 100%),
      image("assets/jasp-ordinal-regression-error.png", width: 100%),
    ),
    caption: [Immediately after importing the data, the variable type of the variable "apply" (ordinal) is set to "Nominal" by JASP.],
    placement: none,
  ) <fig:jasp-ordinal-regression-error>

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      #screenshot("assets/jasp-incompatible-bernoulli-model.png")[
        JASP shows a red warning during model specification because the currently selected model is unfit for the data.
      ] <fig:jasp-incompatible-bernoulli-model>
    ],
    [
      #screenshot("assets/jasp-hidden-ordinal-regression.png")[
        Ordinal Logistic Regression is located under the "Other" model family in JASP.
      ] <fig:jasp-hidden-ordinal-regression>
    ],
  )

  #screenshot("assets/jasp-automatic-interaction-terms.png")[
    JASP adds interaction terms for all factors to the model automatically.
    The ability to remove them is located under the "Model" tab.
  ] <fig:jasp-automatic-interaction-terms>

  == Jamovi

  Jamovi is a free and open-source statistical program with a graphical user interface that is powered by R and does not require users to write code.
  In Jamovi, ordinal logistic regression is directly accessible through the "Ordinal Outcomes" option in the "Regression" menu, as shown in @fig:jamovi-ordinal-regression-menu.
  Naming the option after the outcome type helps users identify the appropriate model for their data even if they are not familiar with the name of the model itself.

  Unlike JASP, Jamovi does not prevent users from fitting an ordinal regression model when the outcome variable "apply" is set to "Nominal", as shown in @fig:jamovi-default-level-order.
  In the example, the default level order shown in the figure is "somewhat likely", "unlikely", "very likely", which does not match the intended order of the responses.
  Jamovi also allows users to specify labels for the levels of a variable @jamovi_data_variables.
  Jamovi also provides an R Syntax Mode that generates equivalent R code for each analysis and allows users to copy it into an R session @jamovi_r_syntax.

  #grid(
    columns: (1fr, 1fr),
    gutter: 1em,
    [
      #screenshot("assets/jamovi-ordinal-regression-menu.png")[
        The regression menu identifies the required outcome type for each model family and includes ordinal logistic regression under "Ordinal Outcomes".
      ] <fig:jamovi-ordinal-regression-menu>
    ],
    [
      #screenshot("assets/jamovi-default-level-order.png")[
        After the user selects "Ordinal Outcomes", Jamovi fits the model using the default level order without requiring confirmation or input.
      ] <fig:jamovi-default-level-order>
    ],
  )

  #pagebreak()

  = Design and Implementation

  This chapter first presents the design and feature goals for our tool and then describes the implemented workflow, results pages, and AI chatbot.
  The goals draw on our observations of JASP and Jamovi and our own ideas about what would make a useful tool for the target audience.

  The tool is intended for HCI researchers who have some experience with statistical analysis but little or no statistical background.
  It aims to allow them to analyze their data using CLM(M)s without having to learn R or Python.
  The target audience also includes researchers who are unsure which results to report and how to present them in text or visualizations.

  == Design and Feature Goals

  @fig:design-goals summarizes the design and feature goals for our tool, grouped by priority and marked with their implementation status.

  #design-goals <fig:design-goals>

  === Must-have

  The must-have goals have been implemented through the workflow and interface features described below.

  When adding a variable, users should be prompted to check its type and, for ordinal variables, reorder the levels if necessary.
  This goal follows from the problems with default variable types and level orders observed in JASP and Jamovi, as shown in @fig:jasp-ordinal-regression-error and @fig:jamovi-default-level-order.

  Model selection should be guided by the outcome type, with the regression family derived from the selected type and explained before fitting.
  This should make model selection accessible to users who may not know which regression family is appropriate for their data.
  The goal is motivated by the difficulty of finding ordinal regression in JASP, as shown in @fig:jasp-hidden-ordinal-regression.

  Interaction terms should require deliberate selection during model specification.
  Users should be able to review, add, and remove interactions alongside the other model terms before fitting.
  This goal is motivated by JASP adding all interactions between factors by default and placing the controls for removing them in a separate tab, as shown in @fig:jasp-automatic-interaction-terms and documented in the JASP QML guide @jaspqmlguide.

  Model specification should be separate from fitting, with users guided through the specification steps and asked to confirm before fitting the model.
  This makes fitting a deliberate action and addresses the observation that JASP can display error messages during incomplete model specification, as shown in @fig:jasp-incompatible-bernoulli-model.
  The separation is also intended to discourage repeated model changes aimed at obtaining significant results.

  The tool should also help users understand model specification and results through explanations and tooltips where they select model terms or interpret the output.
  Statistical terms, reported values, and plots should be explained in accessible language.
  This goal reflects the target audience's limited statistical background and potential unfamiliarity with CLM(M)s.

  === Nice-to-have

  The nice-to-have goals include suggesting variable types and level order using a lightweight LLM, providing a chatbot that can answer questions about the model and results, and allowing users to reopen previous analyses.
  These features have been implemented and are described in the workflow and chatbot sections below.

  The tool also implements the goal of exporting the specified model as reproducible R code.
  This makes the model specification transparent and allows analyses to be reproduced outside the interface.

  Sensitivity analysis using bootstrapped data is another completed nice-to-have goal.
  In the current implementation, it is used only for the plots, where users can display bootstrap 95% confidence intervals.

  Future versions should also allow users to specify descriptive labels for the levels of a variable, as supported by Jamovi @jamovi_data_variables.
  The current implementation allows variables to be renamed but does not support labels for individual levels.


  === Rejected Approach

  We initially considered treating ordinal predictors as continuous when this improved the model's AIC and retaining ordinal coding otherwise.
  We rejected this approach because it made model interpretation less intuitive.

  == General Workflow for Model Specification

  Users can start an analysis by uploading a CSV file or reopen a previous analysis from the landing page shown in @fig:clmm-tool-start-analysis.
  After a CSV file is uploaded, an LLM profiles the variables before the first step of model specification.
  A loading screen with a spinner is displayed during profiling.

  #screenshot("assets/clmm-tool-start-analysis.png")[
    Landing page with buttons to upload a CSV file or reopen a past analysis.
  ] <fig:clmm-tool-start-analysis>

  The workflow then guides users through selecting an outcome variable, fixed effects, and optional random effects and interactions.
  In the first step, shown in @fig:clmm-tool-outcome-selection, users choose the outcome variable.
  An information box explains what an outcome variable is, while a filter and sorting options help users find the variable they want to use.
  The model formula initially contains placeholders and is updated as users specify the model.

  #screenshot("assets/clmm-tool-outcome-selection.png", placement: top)[
    First step of model specification, with the available variables on the left and a drop zone for the outcome and the model formula on the right.
  ] <fig:clmm-tool-outcome-selection>

  When a variable is dragged into a drop zone for the outcome, a predictor, or a random effect, its settings open automatically, as shown in @fig:clmm-tool-variable-type-dialog.
  This prompts users to check the variable type and, for ordinal variables, the order of the levels before proceeding.
  Users can override the variable type and level order suggested by the LLM.

  #screenshot("assets/clmm-tool-variable-type-dialog.png", placement: top)[
    Variable settings for the outcome "apply", showing its ordinal type and editable level order.
  ] <fig:clmm-tool-variable-type-dialog>

  After model specification, a dialog displays the inferred regression family and explains why it was chosen, as shown in @fig:clmm-tool-regression-family-dialog.
  Users can confirm to fit the model or return to change the outcome's variable type.

  #screenshot("assets/clmm-tool-regression-family-dialog.png", placement: top)[
    Confirmation dialog explaining the choice of a CLM based on the ordinal outcome variable.
  ] <fig:clmm-tool-regression-family-dialog>

  == Results Page

  The "Summary" page is divided into two parts, as shown in @fig:clmm-tool-model-summary.
  On the left, a formatted table presents the model output from R, including the AIC, model terms, estimates, standard errors, z values, and p-values.
  Users can switch between the table and a visual representation of the model summary.
  Statistical terms are explained in accessible language through tooltips.
  On the right, a brief paragraph describes the fitted model and its main effects.
  Below this text, "Health Details" provides information related to the model's health, such as the maximum gradient and whether the model satisfies the assumption of proportional odds.
  Users can also export the code used to fit the model in R, which allows them to reproduce the analysis outside the interface or to provide it as supplementary material for a publication.

  #screenshot("assets/clmm-tool-model-summary.png", placement: top)[
    Summary page with model output on the left and a text summary and health details on the right.
  ] <fig:clmm-tool-model-summary>

  The "Fixed Effects" page provides plots for each fixed effect, as shown in @fig:clmm-tool-fixed-effects.
  For categorical predictors, the relative view shows differences in predicted probabilities for each response category compared to the reference level, which is the first level of the factor.
  The tool performs a sensitivity analysis using bootstrapped data, which is currently used only for the fixed effects plots.
  Users can display the resulting bootstrap 95% confidence intervals as error bars.

  #screenshot("assets/clmm-tool-fixed-effects.png", placement: top)[
    Fixed Effects page showing differences in predicted probabilities for "pared", comparing level 1 to the reference level 0.
  ] <fig:clmm-tool-fixed-effects>

  == AI Chatbot

  An optional AI chatbot is located in the bottom right of the interface and is open by default, as shown in @fig:clmm-tool-outcome-selection.
  It uses GPT 5.4 mini to provide explanations about the model and results.

  The chatbot receives context about the dataset's filename and dimensions, as well as the selected outcome, predictors, interactions, and random effects.
  This context also includes the ordering of ordinal categories confirmed by the user and the inferred regression family.
  After fitting, this context also includes the information displayed in the model summary, such as coefficients, p-values, and AIC, as well as the model's health details.
  No raw observations or dataset rows are sent to the LLM provider, OpenAI.

  The chatbot can only provide explanations and cannot change the model, fit new models, or modify the data.
  The current implementation is stateless, meaning that it does not retain previous messages.

  #place.flush()

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


  == Complex Scenario




  // = Results
  // Results of the user study

  = Discussion


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
