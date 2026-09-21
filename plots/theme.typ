#let clm-color = rgb("#0072B2")
#let rstudio-color = rgb("#D55E00")
#let ink = luma(20%)
#let muted-ink = luma(42%)
#let grid-color = luma(84%)

#let plot-text(body, size: 8pt, weight: "regular", fill: ink) = text(
  font: "Libertinus Serif",
  size: size,
  weight: weight,
  fill: fill,
  body,
)

#let one-decimal(value) = str(calc.round(value, digits: 1))
#let two-decimal(value) = str(calc.round(value, digits: 2))
