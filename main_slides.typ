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
    // show-notes-on-second-screen: right,
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
  - this can suggest a difference where none exists, miss a real difference, or reverse its direction @liddell2018analyzing.

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

=== User Study

- Pilot study:
  - feedback shifted the main study's focus toward interpreting model output
- Main study:
- 96 participants from the bachelor's course "Usable Security and Privacy"
  - received basic regression training
  - one failed the screening question and was excluded

=== Study Conditions & Scenarios

- Each participant interpreted two pre-fitted models, one per condition; scenario order and condition assignment were counterbalanced.
- Conditions: tool results with prepared interpretations and no live chatbot; RStudio output with Google and ChatGPT access during free-form interpretation.
- Scenarios: a simple CLM and a CLMM with an interaction and two random intercepts.

=== Results: Task Accuracy

#report-plot(performance-chart)[
  Mean accuracy across 3 questions in the simple scenario and 5 in the complex scenario
]

=== Results: Perceived Understanding

#report-plot(understanding-chart)[
  Self-rated understanding after each scenario, from 0 to 10
]

=== Results: Usability & Preference

#report-plot(preference-chart, zoom: 139%)[
  Mean comparative ratings: 0 favors RStudio output, 10 favors the tool; 5 is neutral
]

=== Discussion

- Perceived understanding was higher with the tool in both scenarios; accuracy was higher only in the complex scenario.
- The findings suggest potential for supporting interpretation of complex model output.
- Prepared text, plots, and interface design were evaluated together, so their individual contributions remain unclear.

=== Limitations & Future Work

- Student participants and two different scenarios limit generalization and conclusions about model complexity.
- The study used prepared interpretations and closed-question accuracy; the full workflow and live AI support still need evaluation.
- Next steps: evaluate the complete workflow and compare alternative visualizations for interpretation tasks.

=== Conclusion

- CLM(M)-tool combines guided model specification with support for interpreting ordinal regression results.
- Participants favored the study interface; task accuracy varied by scenario.
- The next evaluation should test researchers using the complete tool on their own analyses.

= Live Demo

=== References

#set text(size: 17pt, hyphenate: false)
#set par(justify: false)

#bibliography("bibliography.bib", title: none, style: "ieee")
