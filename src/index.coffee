#!/usr/bin/env coffee


coffee_label = (code)=>
  li = []
  code = code.split("\n")
  pre_indent = 0
  pre = 0
  -0
  `OUT: //`
  for line from code
    s = line.trimStart()
    indent = line.length - s.length
    if pre
      li.push ''.padEnd(pre_indent)+"if null #"+pre.trim()
      pre = 0

    if s.startsWith ':'
      pos = s.search /\s/
      if ~pos
        li.push ''.padEnd(indent)+'$|' + s[pos..]
      else
        pre_indent = indent
        pre = line
    else
      c0 = s.charAt(0)
      if (~ '+<'.indexOf(c0)) and ' ' == s.charAt(1)
        s = s[2..].split(',').map((i)=>i.trim()).filter(Boolean)
        indent = ''.padEnd indent
        for i in s
          if i.indexOf('=') < 0
            i += '=`undefined`#'+c0
          if c0 == '<'
            i = 'export '+i
          li.push indent+i
      else
        for word from ['break ','continue ']
          if s.startsWith(word)
            li.push line.replace(word,'`'+word)+'`'
            `continue OUT`
        li.push line

  li.join '\n'


label = (code)=>
  li = []
  for line in code.split('\n')
    s = line.trimStart()
    indent = line.length - s.length
    push = (txt)=>
      li.push ''.padEnd(indent)+txt
      return

    if s.endsWith ' = undefined; //+'
      continue
    else if s.endsWith ' = undefined; //<'
      li.push line[..-18]+';'
    else if s.startsWith 'if (null) { //:'
      push s[15..]+' : {'
    else if s.startsWith '$ | ('
      s = s[4..]
      if s.indexOf('function(') > 0 or s.indexOf('=>') > 0
        txt = s
      else
        txt = s[1...-2]+';'
      push '$ : '+txt
    else if s.startsWith '(() => { //:'
      push s[12..]+' : ({'
    else
      li.push line
  li.join '\n'


export coffee_label_patch = (CoffeeScript)=>
  {compile} = CoffeeScript
  compile.bind CoffeeScript
  (code, ...args)=>
    code = coffee_label code

    r = compile code,...args
    if typeof(r) == 'string'
      return label(r)
    else
      r.js = label(r.js)
      return r

export default hack_for_svelte = (CoffeeScript)=>
  CoffeeScript.compile = coffee_label_patch CoffeeScript
