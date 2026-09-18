#import "typst-article-template/ubo.typ": ubo-blue

#let goal(status, body) = [
  #body
  #linebreak()
  #text(size: 9pt, style: "italic", fill: luma(35%))[#status]
]

#let design-goals = figure(
  block(width: 100%)[
    #set text(size: 10pt, hyphenate: false)
    #set par(justify: false, first-line-indent: 0pt, leading: 0.5em, spacing: 0.9em)
    #set list(tight: false, indent: 0pt, body-indent: 0.65em, spacing: 0.8em)

    #grid(
      columns: (1fr, 1fr, 1fr),
      align: left + top,
      inset: (x: 8pt, y: 9pt),
      stroke: (x, y) => (
        left: if x > 0 { 0.5pt + luma(65%) } else { none },
        bottom: if y == 0 { 0.5pt + luma(65%) } else { none },
      ),
      ..("Must-have", "Nice-to-have", "Rejected").map(title => text(
        font: "Libertinus Sans",
        weight: "bold",
        fill: ubo-blue,
        title,
      )),
      [
        - #goal("Completed")[Provide a guided workflow for specifying CLM(M)s and interpreting results without programming]
        - #goal("Completed")[Require users to review variable types, level order (if applicable) and inferred model family before fitting the model]
        - #goal("Completed")[Explain all important terms and results with tooltips and information boxes]
        - #goal("Completed")[Make interactions explicit and editable during model specification]
      ],
      [
        - #goal("Completed")[Suggest variable types and level order using a lightweight LLM]
        - #goal("Completed")[Context-aware AI chatbot that can answer questions about the model and results]
        - #goal("Completed")[Reopen prior analyses]
        - #goal("Not completed")[Specify descriptive labels for variable levels]
        - #goal("Completed")[Export model specifications as reproducible R code]
        - #goal("Completed")[Perform sensitivity analysis using bootstrapped data]
      ],
      [
        - #goal("Not pursued")[Choose continuous or ordinal coding per predictor using AIC]
      ],
    )
  ],
  kind: image,
  caption: [Design and feature goals grouped by priority, with their implementation status.],
  placement: none,
)
