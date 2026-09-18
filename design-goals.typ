#import "typst-article-template/ubo.typ": ubo-blue

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
        - Provide a guided workflow for specifying CLM(M)s and interpreting results without programming
        - Require users to review variable types, level order (if applicable) and inferred model family before fitting the model
        - Explain all important terms and results with tooltips and information boxes
        - Make interactions explicit and editable during model specification
      ],
      [
        - Suggest variable types and level order using a lightweight LLM
        - Context-aware AI chatbot that can answer questions about the model and results
        - Reopen prior analyses
        - Specify descriptive labels for variable levels
        - Export model specifications as reproducible R code
      ],
      [
        - Choose continuous or ordinal coding per predictor using AIC
      ],
    )
  ],
  kind: image,
  caption: [Design goals and ideas grouped by priority.],
  placement: none,
)
