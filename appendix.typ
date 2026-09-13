#import "screenshot.typ": screenshot

#counter(heading).update(0)
#show heading.where(level: 1): set heading(numbering: "A")
#show heading.where(level: 2): set heading(numbering: "A.1")
#show heading.where(level: 3): set heading(numbering: "A.1.1")

= Supplementary Material <appendix-material>

== CLMM-Tool Group

=== Simple Scenario

#screenshot("assets/user-study-tool-simple-model-summary.png")[
  Model summary, coefficient forest plot, and interpretation for the simple scenario.
]

#screenshot("assets/user-study-tool-simple-predicted-probabilities.png")[
  Predicted probabilities and average marginal effects for the simple scenario.
]

=== Complex Scenario

#screenshot("assets/user-study-tool-complex-model-summary.png")[
  Model summary, simple-effects plot, and interpretation for the complex scenario.
]

#screenshot("assets/user-study-tool-complex-predicted-probabilities.png")[
  Predicted rating probabilities and simple-effects plot for the complex scenario.
]

== LLM-Assisted Analysis Group

=== Simple Scenario
// TODO: Actually add

=== Complex Scenario

// TODO: Actually add
