#import "@preview/cetz:0.4.2"
#import "theme.typ": *

#let data = json("../Auswertung/prepared/plot_data.json").preference

#let preference-chart = cetz.canvas(length: 1cm, {
  import cetz.draw: *

  let left = 3.55
  let bottom = 1.35
  let width = 9.8
  let x(value) = left + value / 10 * width
  let items = (
    (source: "Benutzerfreundlichkeit", label: "More user-friendly", y: 6.3),
    (source: "Unterstützung", label: "Better support", y: 4.35),
    (source: "Präferenz", label: "Preferred tool", y: 2.4),
  )

  rect((0, 0), (14.2, 7.55), stroke: none, fill: none)

  for tick in range(0, 11, step: 2) {
    line(
      (x(tick), bottom),
      (x(tick), 6.95),
      stroke: 0.45pt + grid-color,
    )
    content(
      (x(tick), bottom - 0.25),
      plot-text([#tick], fill: muted-ink),
      anchor: "north",
    )
  }

  line(
    (x(5), bottom),
    (x(5), 6.95),
    stroke: (paint: muted-ink, thickness: 0.7pt, dash: "dashed"),
  )
  line((left, bottom), (left + width, bottom), stroke: 0.7pt + ink)

  for item in items {
    let row = data.find(row => row.item == item.source)
    let mean = float(row.mean)

    content(
      (left - 0.3, item.y),
      plot-text([#item.label], size: 8.5pt),
      anchor: "east",
    )
    circle((x(mean), item.y), radius: 0.15, fill: clm-color, stroke: 0.7pt + white)
    content(
      (x(mean), item.y + 0.35),
      plot-text([#two-decimal(mean)], size: 8.5pt, weight: "bold"),
      anchor: "south",
    )
  }

  content(
    (left, 0.48),
    plot-text([RStudio output], size: 8.5pt, fill: rstudio-color),
    anchor: "north-west",
  )
  content(
    (left + width, 0.48),
    plot-text([CLM tool], size: 8.5pt, fill: clm-color),
    anchor: "north-east",
  )
})
