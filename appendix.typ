#import "screenshot.typ": screenshot

#let study-listing(source, caption, lang: none) = figure(
  {
    show raw: set text(size: 8pt)
    set par(justify: false, first-line-indent: 0pt, leading: 0.4em)
    show raw.where(block: true): code => grid(
      columns: (1fr,),
      row-gutter: 0.4em,
      ..code.lines.map(line => if line.text == "" { v(0.7em) } else { line.body }),
    )
    raw(read(source), block: true, lang: lang)
  },
  kind: raw,
  caption: caption,
  placement: none,
)

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

== CLM Tool Condition

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

#pagebreak(weak: true)

== RStudio Condition <appendix-llm-analysis>

=== Simple Scenario <appendix-simple-analysis>

The original simple-scenario fitting script and output were not available. #footnote([Danke sciebo, `[object][Object]` ist sehr hilfreich])
The script below was recreated from the documented model specification and is expected to accurately reproduce the original analysis.
The displayed output was regenerated using this recreation.

#study-listing("Studie/fit_simple_model_recreation.R", lang: "r")[
  Recreated R script for the simple scenario.
]

#study-listing("Studie/simple_fit_model_output.txt")[
  Model summary regenerated using the recreated simple-scenario script.
]

#pagebreak(weak: true)

=== Complex Scenario <appendix-complex-analysis>

The original complex-scenario fitting script and its output.

#study-listing("Studie/fit_model.R", lang: "r")[
  Original R script for the complex scenario.
]

#study-listing("Studie/complex_fit_model_output.txt")[
  Saved model summary for the complex scenario.
]

#pagebreak(weak: true)

== Complex-Scenario Data Preparation <appendix-subsample>

The following original script documents how the 400-row subsample was drawn from the `InstEval` dataset in the `lme4` package.

#study-listing("Studie/derive_subsample.R", lang: "r")[
  Original R script for deriving the complex-scenario dataset.
]
