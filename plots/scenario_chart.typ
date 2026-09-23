#import "@preview/cetz:0.4.2"
#import "theme.typ": *

// Shared axis, grouping, data labels, and legend for the two scenario figures.
#let scenario-chart(data, max-value: 10, tick-step: 2, axis-label: [], kind: "point", value-suffix: []) = cetz.canvas(length: 1cm, {
  import cetz.draw: *

  let left = 1.5
  let bottom = 1.35
  let width = 11.8
  let height = 6.0
  let y(value) = bottom + value / max-value * height
  let is-bar = kind == "bar"
  let scenario-centers = (4.1, 9.6)
  let tools = (
    (name: "CLM tool", color: clm-color,
      offset: if is-bar { -0.82 } else { -0.55 }),
    (name: "RStudio output", color: rstudio-color,
      offset: if is-bar { 0.82 } else { 0.55 }),
  )
  let scenarios = (
    (name: "simple", label: "Simple scenario"),
    (name: "complex", label: "Complex scenario"),
  )

  rect((0, 0), (14.2, 8.35), stroke: none, fill: none)

  for tick in range(0, max-value + 1, step: tick-step) {
    line(
      (left, y(tick)),
      (left + width, y(tick)),
      stroke: if tick == 0 { 0.7pt + ink } else { 0.45pt + grid-color },
    )
    content(
      (left - 0.22, y(tick)),
      plot-text([#tick], fill: muted-ink),
      anchor: "east",
    )
  }

  line((left, bottom), (left, bottom + height), stroke: 0.7pt + ink)
  content(
    (0.28, bottom + height / 2),
    plot-text(axis-label, size: 8.5pt),
    angle: 90deg,
  )

  for (scenario-index, scenario) in scenarios.enumerate() {
    let center = scenario-centers.at(scenario-index)
    content(
      (center, 0.78),
      plot-text([#scenario.label], size: 8.5pt),
      anchor: "north",
    )

    for tool in tools {
      let row = data.find(row => (
        row.scenario == scenario.name and row.tool == tool.name
      ))
      let mean = float(row.mean)
      let n = int(row.n)
      let x = center + tool.offset

      if is-bar {
        let bar-width = 1.35
        rect(
          (x - bar-width / 2, bottom),
          (x + bar-width / 2, y(mean)),
          fill: tool.color,
          stroke: none,
        )
        content(
          (x, y(mean) + 0.28),
          plot-text([#one-decimal(mean)%], size: 8.5pt, weight: "bold"),
          anchor: "south",
        )
        content(
          (x, bottom + 0.32),
          plot-text([#emph[n = #n]], size: 7.5pt, fill: white),
        )
      } else {
        if tool.name == "CLM tool" {
          circle((x, y(mean)), radius: 0.14,
            fill: tool.color, stroke: 0.7pt + white)
        } else {
          rect(
            (x - 0.13, y(mean) - 0.13),
            (x + 0.13, y(mean) + 0.13),
            fill: tool.color,
            stroke: 0.7pt + white,
          )
        }
        let value-label = [#one-decimal(mean)#value-suffix]
        content(
          (x, y(mean) + 0.34),
          plot-text(value-label, size: 8.5pt, weight: "bold"),
          anchor: "south",
        )
        content(
          (x, y(mean) - 0.34),
          plot-text([#emph[n = #n]], size: 7.2pt, fill: muted-ink),
          anchor: "north",
        )
      }
    }
  }

  let legend-y = 8.0
  if is-bar {
    rect((4.15, legend-y - 0.12), (4.47, legend-y + 0.12),
      fill: clm-color, stroke: none)
    rect((8.15, legend-y - 0.12), (8.47, legend-y + 0.12),
      fill: rstudio-color, stroke: none)
    content((4.61, legend-y), plot-text([CLM tool], size: 8.5pt),
      anchor: "west")
    content((8.61, legend-y), plot-text([RStudio output], size: 8.5pt),
      anchor: "west")
  } else {
    circle((4.24, legend-y), radius: 0.13, fill: clm-color, stroke: none)
    rect((8.04, legend-y - 0.12), (8.28, legend-y + 0.12),
      fill: rstudio-color, stroke: none)
    content((4.52, legend-y), plot-text([CLM tool], size: 8.5pt),
      anchor: "west")
    content((8.48, legend-y), plot-text([RStudio output], size: 8.5pt),
      anchor: "west")
  }
})
