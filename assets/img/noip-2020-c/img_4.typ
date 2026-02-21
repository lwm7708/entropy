#import "@preview/cetz:0.4.1"

#import "constants.typ": *

#set page(width: auto, height: auto, margin: 0mm)

#set text(20pt, fill: color-fg)

#cetz.canvas(
  {
    cetz.draw.set-style(stroke: color-fg + 1.5pt)
    cetz.draw.line((0, 0), (width * 3 + gap_x * 6, 0))
    cetz.draw.rect((gap_x * 2, 0), (rel: (width, m)), fill: color-red)
    cetz.draw.rect((width + gap_x * 3, 0), (rel: (width, m)), fill: color-blue)
    cetz.decorations.flat-brace((gap_x * 2 - 1, gap_y), (rel: (0, m - gap_y * 2)))
    cetz.decorations.flat-brace(
      (width * 2 + gap_x * 3 + 1, gap_y), (rel: (0, m - gap_y * 2)), flip: true
    )
    cetz.draw.content((gap_x * 2 - amt_x, m / 2 + amt_y), anchor: "mid-east", [$m$])
    cetz.draw.content((width * 2 + gap_x * 3 + amt_x, m / 2 + amt_y), anchor: "mid-west", [$m$])
  },
  background: color-bg, padding: 8mm
)
