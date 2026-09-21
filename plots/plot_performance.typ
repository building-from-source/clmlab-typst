#import "scenario_chart.typ": scenario-chart

#let data = json("../Auswertung/prepared/plot_data.json").performance

#let performance-chart = scenario-chart(
  data,
  max-value: 100,
  tick-step: 20,
  axis-label: [Mean correct answers (%)],
  kind: "bar",
)
