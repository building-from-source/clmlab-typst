#import "scenario_chart.typ": scenario-chart

#let data = json("../Auswertung/prepared/plot_data.json").understanding

#let understanding-chart = scenario-chart(
  data,
  max-value: 10,
  tick-step: 2,
  axis-label: [Mean rating (0-10)],
  kind: "point",
)
