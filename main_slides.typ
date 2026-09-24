#import "@local/ubo_typst_slides:1.0.0": *
#import "@preview/cetz:0.4.2"

#show: ubo-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [CLM(M)-tool],
    authors: (
      (
        name: "Julian Steffen",
        institution: "University of Bonn",
      ),
    ),
    date: datetime.today(),
  ),
  config-lecture(
    handout: handout-mode,
    justify: true,
    font: "Exo 2",
  ),
  config-page(),
)

#title-slide()

= Motivation

=== Add your first slide
