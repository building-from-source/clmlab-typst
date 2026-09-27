#import "ubo_typst_slides/lib.typ": *
#import "plots/plot_performance.typ": performance-chart
#import "plots/plot_understanding.typ": understanding-chart
#import "plots/plot_preference.typ": preference-chart

#let report-plot(body, caption, zoom: 126%) = align(center)[
  #set par(justify: false)
  #scale(x: zoom, y: zoom, reflow: true, body)
  #v(6pt)
  #text(size: 17pt, caption)
]

#let source-note(body) = [
  #v(1.4em)
  #line(length: 100%, stroke: 0.5pt + colorgray)
  #v(0.35em)
  #set par(justify: false)
  #text(size: 12pt, fill: colorgray)[#body]
]

#let source-ref(key) = [
  #cite(key) #h(0.2em) #cite(key, form: "author") (#cite(key, form: "year"))
]

// Enlarge a detail of the original screenshot without changing its image file.
#let screenshot-detail(file, original-size, region, width: 440pt) = {
  let unit = width / region.width
  box(width: width, height: region.height * unit, clip: true)[
    #place(top + left, dx: -region.x * unit, dy: -region.y * unit, box(
      width: original-size.at(0) * unit,
      height: original-size.at(1) * unit,
      image(file, width: 100%, height: 100%),
    ))
  ]
}

#show: ubo-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [CLM(M)-tool],
    subtitle: [Final Presentation Lab Usable Security and Privacy ],
    authors: (
      (
        name: "Julian Steffen",
        institution: "University of Bonn",
      ),
    ),
    // event: [Name of the event],
    location: [Bonn, Germany],
    date: datetime.today(),
  ),
  config-lecture(
    handout: handout-mode,
    show-notes-on-second-screen: right,
    justify: true,
    font: "Calibri",
  ),
  config-page(),
)

#title-slide()


=== Ordinal Measures & HCI
- Ordinal responses are common in HCI
  - e.g. Likert items
- Some commonly used analyses treat ordinal responses as equally spaced
  - this can suggest an effect where none exists, miss a real effect, or reverse its direction @liddell2018analyzing.

#pause

#v(1em)
#align(
  center,
)[In a sample of 94 CHI 2024 papers, 10 of 28 predictive model analyses used a CLM or CLMM @Victor_Syiem_2026.]

#source-note[
  #source-ref(<liddell2018analyzing>)
  #linebreak()
  #source-ref(<Victor_Syiem_2026>)
]

=== CLMs & CLMMs

- Cumulative Link Models (CLMs)
  - account for ordered outcome categories without assuming equal spacing
  - `clm(rating ~ contact + temp, data=wine)`
- Cumulative Link Mixed Models (CLMMs)
  - extend CLMs with random effects for grouped or repeated observations
  - `clmm(rating ~ contact + temp + (1|judge), data=wine)`

=== JASP/Jamovi

#grid(
  columns: (1fr, 0.45fr),
  gutter: 1em,

  // Left side
  [
    #set par(justify: false)
    - Free and open-source statistics software for analyzing data without programming
    - In the ordinal regression workflows we examined:
      - *Specification:* limited guidance for checking data settings and specifying the model
      - *Terminology:* statistical knowledge assumed; unfamiliar terms require separate lookup
      - *Interpretation:* default results are tables without accompanying plots
  ],
  // Right side
  box(
    height: 100%,
    width: 100%,
    grid(
      rows: (1fr, 1fr),
      align(top + center)[
        #image("assets/jasp-welcome-screen.png", width: 100%)
      ],
      align(bottom + center)[
        #image("assets/jamovi-empty-workspace.png", width: 100%)
      ],
    ),
  ),
)

// === Target Audience & Project Goal

// - HCI researchers with some analysis experience and limited statistical background.
// - Goal: support model specification and interpretation without requiring R or Python.
// - Contribution: a web-based tool and a study of interpretation support.

=== CLM(M)-tool

#grid(
  columns: (1fr, 0.85fr),
  gutter: 1em,

  // Left half
  [
    #set par(justify: false)
    - Web-based tool for HCI researchers to analyze ordinal data without programming
    - Core Design Principles:
      - *Specification:* guide users through model specification
      - *Terminology:* explain statistical terms in plain language
      - *Interpretation:* support understanding with explanations and plots
  ],

  // Right half
  align(center + horizon)[
    #image(
      "assets/clmm-tool-variable-type-dialog.png",
      width: 100%,
    )
  ],
)

=== Results: Task Accuracy

#report-plot(performance-chart)[
  Mean task accuracy: 3 questions in the simple scenario and 5 in the complex scenario
]

=== Results: Self-Rated Understanding

#report-plot(understanding-chart)[
  Mean self-rated understanding after each scenario, on a scale from 0 to 10
]

=== Results: Comparative Ratings

#report-plot(preference-chart, zoom: 139%)[
  Mean comparative ratings: 0 favors RStudio output, 10 favors the CLM(M) tool; 5 is neutral
]

=== Limitations// & Future Work

- *Study scope*
  - Prepared results page; full workflow and live LLM responses were not evaluated
- *Generalization*
  - Student participants and only two scenarios
  - Scenarios differed in subject matter and questions, not just model complexity
- *Task accuracy*
  - Predefined answers may provide cues; scores do not directly assess interpretation in participants' own words
// - *Next steps*
//   - Evaluate the complete workflow and LLM-generated interpretations
//   - Compare alternative visualizations for interpretation tasks

=== Conclusion

- CLM(M)-tool guides model specification and supports interpretation through explanations and plots
- The prepared study interface received higher self-rated understanding and favorable comparative ratings; task accuracy varied by scenario
- Further evaluation should examine alternative visualizations and the complete workflow, including live LLM responses

= Live Demo

=== References

#set text(size: 17pt, hyphenate: false)
#set par(justify: false)

#bibliography("bibliography.bib", title: none, style: "ieee")

#let backup-slide(title, body) = slide(
  config: utils.merge-dicts(
    config-common(freeze-slide-counter: true),
    config-page(
      header: self => slide-header(self, custom-heading: title),
      footer: none,
    ),
  ),
  body,
)

#backup-slide[Alternative Visualization: Modified CCDF][
  #speaker-note[
    - Sarma's example: moral-permissibility ratings, 1 to 7
    - higher means more permissible
    - orange is the baseline
    - act. = action, int. = intention, con. = contact; no = absent.
    - X: rating threshold
    - Y: probability of that rating or higher
    - The 0.5 line helps locate the median category
    - Shading: uncertainty in estimated probabilities
  ]

  #set par(justify: false)

  Modified Complementary Cumulative Distribution Function (mCCDF) plots @sarma2026adapting

  #v(0.5em)
  #grid(
    columns: (1fr, 1.3fr),
    gutter: 1em,
    align: horizon,
    [
      - Rating at least $k$: $P(Y >= k)$
      - Median at $Y = 0.5$
    ],
    [
      #screenshot-detail(
        "assets/sarma-2026-ccdf-conditions.png",
        (2167, 2600),
        (x: 0, y: 795, width: 2167, height: 960),
        width: 420pt,
      )
    ],
  )

  #source-note[
    #source-ref(<sarma2026adapting>) #h(0.4em) Figure 4B
  ]
]

#backup-slide[User Study][

  - Evaluated support for interpreting pre-fitted ordinal regression results
  - *Participants*
    - Bachelor's students in computer science or cyber security
    - received basic regression training
    - 95 included in the analysis after one screening exclusion
  - *Measures*
    - Task accuracy: proportion of correctly answered questions
    - Self-rated understanding
    - Comparative ratings of perceived support during interpretation, perceived user-friendliness, and preference for future regression interpretation
]

#backup-slide[Study Conditions & Scenarios][

  - *Conditions*
    - CLM(M)-tool: prepared plots and LLM-generated interpretations; no live chatbot
    - RStudio: pre-fitted model output
    - Internet research and external LLMs allowed during familiarization in both conditions
  - *Scenarios*
    - Simple CLM: `apply ~ pared + public + gpa`
    - Complex CLMM: interaction and two random intercepts
      #linebreak()
      #text(size: 18pt)[
        `rating ~ service * studage_group + (1 | student_id) + (1 | instructor_id)`
      ]
  - Each participant completed both scenarios, one per condition
    - Scenario order and condition assignment were counterbalanced
]

#backup-slide[Discussion][
  #set par(justify: false)

  - *Perceived support and task accuracy*
    - Higher self-rated understanding and favorable comparative ratings
    - Accuracy advantage observed only in the complex scenario
  - *Possible explanation*
    - Plots and prepared interpretations may help make relevant information accessible
    - Their individual contributions were not isolated
  - *Implication*
    - Promising descriptive findings; further evaluation across tasks and the complete workflow is needed
]
