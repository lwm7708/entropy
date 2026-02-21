#import "@preview/cetz:0.4.1"

#import "constants.typ": *

#set page(width: auto, height: auto, margin: 0mm)
#set text(20pt, fill: color-fg)

#cetz.canvas(
  {
    cetz.draw.set-style(stroke: color-fg + 1.5pt)
    cetz.draw.line((0, 0), (width * 3 + gap_x * 6, 0))
    cetz.draw.rect((width + gap_x * 3, 0), (rel: (width, m - c)))
    cetz.draw.rect((width + gap_x * 3, m - c), (rel: (width, c)), fill: color-red)
    cetz.draw.rect((width * 2 + gap_x * 4, 0), (rel: (width, c)))
    cetz.draw.rect((width * 2 + gap_x * 4, c), (rel: (width, m - c)), fill: color-blue)
    cetz.decorations.flat-brace((width + gap_x * 3 - 1, gap_y), (rel: (0, m - c - gap_y * 2)))
    cetz.decorations.flat-brace((width + gap_x * 3 - 1, m - c + gap_y), (rel: (0, c - gap_y * 2)))
    cetz.decorations.flat-brace(
      (width * 3 + gap_x * 4 + 1, gap_y), (rel: (0, c - gap_y * 2)), flip: true
    )
    cetz.decorations.flat-brace(
      (width * 3 + gap_x * 4 + 1, c + gap_y), (rel: (0, m - c - gap_y * 2)), flip: true
    )
    cetz.draw.content(
      (width + gap_x * 3 - amt_x, (m - c) / 2 + amt_y), anchor: "mid-east", [$m - c$]
    )
    cetz.draw.content(
      (width + gap_x * 3 - amt_x, (m - c) + c / 2 + amt_y), anchor: "mid-east", [$c$]
    )
    cetz.draw.content((width * 3 + gap_x * 4 + amt_x, c / 2 + amt_y), anchor: "mid-west", [$c$])
    cetz.draw.content(
      (width * 3 + gap_x * 4 + amt_x, c + (m - c) / 2 + amt_y), anchor: "mid-west", [$m - c$]
    )
  },
  background: color-bg, padding: 8mm
)
