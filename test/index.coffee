#!/usr/bin/env coffee

import CoffeeScript from "coffeescript"
import hack from '@rmw/coffee-label-patch'
hack CoffeeScript
console.log CoffeeScript.compile(
  """
y = 0

:$ x=y*2

:$ if y>2 then x+=y else x-=y

:$
  if x > y
    x = y/2
  else
    x = y+9
  x += 1

do =>
  + a,b

:$ func = => 1

:$ func = ->
  1
  2

do =>
  :out
    for i in [1,2,3]
      for j in [4,5,6]
        console.log i,j
        if i > 1
          break out
  return

< x
< x = 1

  """
  bare:true
  #  sourceMap:true
)
