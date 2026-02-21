#import "@preview/cetz:0.4.1"

#import "constants.typ": *

#set page(width: auto, height: auto, margin: 0mm)
#set text(20pt, fill: color-fg)

#cetz.canvas(
  {
    cetz.draw.set-style(stroke: color-fg + 1.5pt)
    cetz.draw.line((0, 0), (width * 3 + gap_x * 6, 0))
    cetz.draw.rect((gap_x * 2, 0), (rel: (width, c)), fill: color-red)
    cetz.draw.rect((gap_x * 2, c), (rel: (width, m - c)), fill: color-blue)
    cetz.draw.rect((width * 2 + gap_x * 4, 0), (rel: (width, m)))
    cetz.decorations.flat-brace((gap_x * 2 - 1, gap_y), (rel: (0, c - gap_y * 2)))
    cetz.decorations.flat-brace((gap_x * 2 - 1, c + gap_y), (rel: (0, m - c - gap_y * 2)))
    cetz.decorations.flat-brace(
      (width * 3 + gap_x * 4 + 1, gap_y), (rel: (0, m - gap_y * 2)), flip: true
    )
    cetz.draw.content((gap_x * 2 - amt_x, c / 2 + amt_y), anchor: "mid-east", [$c$])
    cetz.draw.content((gap_x * 2 - amt_x, c + (m - c) / 2 + amt_y), anchor: "mid-east", [$m - c$])
    cetz.draw.content((width * 3 + gap_x * 4 + amt_x, m / 2 + amt_y), anchor: "mid-west", [$m$])
  },
  background: color-bg, padding: 8mm
)
