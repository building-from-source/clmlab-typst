#import "screenshot.typ": screenshot

#counter(heading).update(0)
#show heading.where(level: 1): set heading(numbering: "A")
#show heading.where(level: 2): set heading(numbering: "A.1")
#show heading.where(level: 3): set heading(numbering: "A.1.1")
#set figure(numbering: (n, ..) => numbering("A.1", 1, n))

= Supplementary Material <appendix-material>

== Screening Questions <appendix-screening-questions>

#block(breakable: false)[
  #set text(lang: "de")
  Wozu dient eine Regressionsanalyse hauptsächlich?

  - Mittelwerte zu vergleichen
  - *Zusammenhänge zwischen Variablen zu analysieren*
  - Zufallsstichproben zu ziehen
  - Daten in Gruppen einzuteilen
]

#linebreak()

#block(breakable: false)[
  #set text(lang: "de")
  Was bedeutet ein R²-Wert von 0,70 in einer Regressionsanalyse?

  - Der Regressionskoeffizient beträgt 0,70.
  - Jede unabhängige Variable erklärt 70 % der abhängigen Variable.
  - Das Modell trifft in 70 % der Fälle richtige Vorhersagen.
  - *Das Modell erklärt 70 % der Variation der abhängigen Variable.*
]

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
