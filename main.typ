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

= Related Software
// Overview of existing software, their limitations / problems

== Jasp

#screenshot("assets/image-13.png")[
  // Write caption here.
]

#screenshot("assets/image-14.png")[
  // Write caption here.
]

#screenshot("assets/image-15.png")[
  // Write caption here.
]

#align(right)[
  *Draft word count:* #total-words
] <word-count-display>

= Design and Implementation
// Description of the design and implementation of the website

- intitial idea:
  - fit models with predictors treated as continous instead of as ordinal, treat as continous if AIC improves, otherwise treat as ordinal
  - was rejected, because it (un-intuitively) makes interpretation of the model more difficult
- minimize friction, while making sure that results are accurate and interpretable
  - profiling 
  - force user to check important info (i.e. variable types) when they pick it as an outcome variable / predictor / random effect

#screenshot("assets/image.png")[
  // Write caption here.
]

#screenshot("assets/image-1.png")[
  // Write caption here.
]

#screenshot("assets/image-2.png")[
  // Write caption here.
]

#screenshot("assets/image-3.png")[
  // Write caption here.
]

#screenshot("assets/image-4.png")[
  // Write caption here.
]

#screenshot("assets/image-5.png")[
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

- for the user study we decided to create outputs / results using our tool and as what someone would get if they worked with LLM-assistance
- the results page of our tool was created to be similar to the actual tool, but enhanced with LLM-assisted interpretations that take the study contetext into account (wizard of oz approach)
- between groups design
- two scenarios each, one "simple" (no random effects, no interactions)

== 1

#screenshot("assets/image-6.png")[
  // Write caption here.
]

#screenshot("assets/image-7.png")[
  // Write caption here.
]

#screenshot("assets/image-8.png")[
  // Write caption here.
]

== 2

#screenshot("assets/image-9.png")[
  // Write caption here.
]

#screenshot("assets/image-10.png")[
  // Write caption here.
]

#screenshot("assets/image-11.png")[
  // Write caption here.
]

#screenshot("assets/image-12.png")[
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

#align(right)[
  *Draft word count:* #total-words
] <word-count-display>
