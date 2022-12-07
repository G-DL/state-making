;; Copyright Gabriele De Luca,
;; Department of e-Governance and Administration,
;; University for Continuing Education Krems, Austria,
;; gabriele.deluca@donau-uni.ac.at

globals [
  referendum
  refugees
  territory_color
  highlander-victory?
]

breed [individuals individual]
breed [fires fire]

undirected-link-breed [connections connection]

individuals-own [
  preference  ; this is the political preference, it can assume any value. Its sign determines the vote expressed by the individual
  in-country?
]

patches-own [
  territory?
]

to setup
  clear-all
  set-default-shape individuals "person"
  set-default-shape fires "fire"
  set territory_color red + 3
  set highlander-victory? False
  make-territory
  repeat number-individuals [ make-individuals ]
  reset-ticks
end

; initialise individuals
to make-individuals
  create-individuals 1 [move-to one-of patches with [territory? = True]
    set size 25
    set preference variance-of-preferences * 1.1 ; otherwise the simulation stops at turn 1 with 50% chances
    set in-country? True
  ]
end

to make-territory
  import-pcolors "borders.png"
  ask patches [set territory? False]
  ask patches with [pcolor = white] [set pcolor yellow + 3]
  ask patches with [pcolor = black] [set pcolor territory_color
      set territory? True]
end

to go
  if (count individuals with [in-country? = True] = 0) [
    set referendum highlanders
    set highlander-victory? True
    stop]
  if (referendum < 0) [
      set highlander-victory? True
    stop]
  if ticks > final-ticks [stop]
  ask individuals [move]
  update-preferences
  make-referendum
  repeat highlanders [kill]
  compute-refugees
  tick
end

to move
  let closest-fires fires in-radius perception-range
  let how_many_fires_in_range count closest-fires; assert whether there are any fires in range
  let fires_in_range? how_many_fires_in_range > 0

  ifelse fires_in_range? [
    let xsum 0
    let ysum 0
    ask closest-fires [set xsum (xsum + xcor)
      set ysum (ysum + ycor)]
    let xaverage (xsum / how_many_fires_in_range)
    let yaverage (ysum / how_many_fires_in_range)
    facexy xaverage yaverage
    left 180
    forward speed * 2
  ]; if True

  [right random 90
  left random 90
  forward speed] ; else
  let currently-on-territory? [territory?] of patch-here
  ifelse (currently-on-territory?) [set in-country? True]
      [set in-country? False]
end

to make-referendum
  ifelse (count individuals with [in-country? = True] > 0 )
; if there are individuals in the country
  [set referendum mean [preference] of individuals with [in-country? = True]
  ]
; else, there are no individuals in the country so the highlanders decide
  [set referendum 0 - highlanders]
end

to update-preferences
  ask individuals [
    let draw random-normal 0 variance-of-preferences
    let update preference + draw
    set preference update]
end

to kill
  let in-country-individuals individuals with [in-country? = True]
  if count in-country-individuals > 0 [
    let murdered one-of in-country-individuals with-max [preference]
    ask murdered [hatch-fires 1 []
      if any? other individuals in-radius perception-range [
        ask other individuals in-radius perception-range [
        ; RUN AWAY GOES HERE
        let draw random-normal 0 variance-of-preferences
        let abs-draw abs draw
        let update preference + abs-draw
        set preference update]      ; I am very sorry but the order of execution for contatenated operations in this language is a mess and this is the only way I am sure that it does what I want
      ]
      die]
  ]
end

to compute-refugees
  set refugees count individuals with [in-country? = False]
end
@#$#@#$#@
GRAPHICS-WINDOW
375
10
1184
820
-1
-1
1.0
1
10
1
1
1
0
0
0
1
-400
400
-400
400
1
1
0
ticks
30.0

PLOT
5
365
365
485
Referendum
Time
Preference
0.0
10.0
-0.05
0.1
true
false
"" ""
PENS
"default" 1.0 0 -2674135 true "" "plot referendum"
"pen-1" 1.0 0 -7500403 true "" "plot 0"

BUTTON
10
10
88
44
setup
setup
NIL
1
T
OBSERVER
NIL
A
NIL
NIL
1

BUTTON
92
10
166
44
NIL
go
T
1
T
OBSERVER
NIL
S
NIL
NIL
1

SLIDER
10
45
184
78
number-individuals
number-individuals
10
100
100.0
1
1
NIL
HORIZONTAL

SLIDER
10
81
183
114
highlanders
highlanders
0
10
2.0
1
1
NIL
HORIZONTAL

BUTTON
169
10
242
44
go once
go
NIL
1
T
OBSERVER
NIL
D
NIL
NIL
0

SLIDER
10
119
183
152
speed
speed
0
50
7.0
1
1
NIL
HORIZONTAL

SLIDER
10
155
182
188
perception-range
perception-range
0
100
60.0
1
1
NIL
HORIZONTAL

MONITOR
215
50
342
95
How many individuals
count individuals
1
1
11

SLIDER
10
190
185
223
variance-of-preferences
variance-of-preferences
0
1
0.4
0.01
1
NIL
HORIZONTAL

MONITOR
215
105
337
150
How many refugees
refugees
0
1
11

MONITOR
215
155
272
200
Ticks
ticks
17
1
11

SLIDER
10
225
182
258
final-ticks
final-ticks
0
1000
30.0
1
1
NIL
HORIZONTAL

MONITOR
215
210
332
255
NIL
highlander-victory?
17
1
11

@#$#@#$#@
## WHAT IS IT?


## HOW IT WORKS


## HOW TO USE IT


## THINGS TO NOTICE


## THINGS TO TRY


## EXTENDING THE MODEL

The file "borders.png" upon which the model depends can be changed with one that represents the political boundaries of some actual countries experiencing civil war or genocide, and then the number of people residing in the country can be changed proportionally to that country's population to allow for cross-country comparisons.

## NETLOGO FEATURES


## RELATED MODELS

None

## CREDITS AND REFERENCES

## HOW TO CITE

## COPYRIGHT AND LICENSE

Copyright 2022 Gabriele De Luca
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fire
false
0
Polygon -7500403 true true 151 286 134 282 103 282 59 248 40 210 32 157 37 108 68 146 71 109 83 72 111 27 127 55 148 11 167 41 180 112 195 57 217 91 226 126 227 203 256 156 256 201 238 263 213 278 183 281
Polygon -955883 true false 126 284 91 251 85 212 91 168 103 132 118 153 125 181 135 141 151 96 185 161 195 203 193 253 164 286
Polygon -2674135 true false 155 284 172 268 172 243 162 224 148 201 130 233 131 260 135 282

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

link
true
0
Line -7500403 true 150 0 150 300

link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>count individuals</metric>
    <metric>refugees</metric>
    <metric>ticks</metric>
    <metric>highlander-victory?</metric>
    <metric>referendum</metric>
    <enumeratedValueSet variable="final-ticks">
      <value value="30"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="perception-range">
      <value value="40"/>
      <value value="50"/>
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="highlanders">
      <value value="1"/>
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-individuals">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="speed">
      <value value="5"/>
      <value value="7"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="variance-of-preferences">
      <value value="0.02"/>
      <value value="0.1"/>
      <value value="0.2"/>
      <value value="0.4"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
1
@#$#@#$#@
