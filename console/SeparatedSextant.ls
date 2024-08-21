
  do ->

    { Num, Bool } = dependency 'primitive.Type'
    { string-from-code-point } = dependency 'native.String'

    sextant-key-suffixes = <[
      1 2 12
      3 13 23 123
      4 14 24 124 34 134 234 1234
      5 15 25 125 35 135 235 1235 45 145 245 1245 345 1345 2345 12345
      6 16 26 126 36 136 236 1236 46 146 246 1246 346 1346 2346 12346 56 156 256 1256 356 1356 2356 12356 456 1456 2456 12456 3456 13456 23456 123456
    ]>

    sextant-code = -> 0x1ce51 + Num it

    sextant-chars = { [ ("sextant-#key-suffix"), (string-from-code-point sextant-code index) ] for key-suffix, index in sextant-key-suffixes }

    sextant-for-key = (key) ->

      switch key

        | 'sextant-' => ' '
        else sextant-chars[ key ]

    new-separated-sextant-char = ->

      bits = void

      clear = !-> bits := [ off for til 6 ]

      clear!

      #

      index = (x, y) -> y + x * 2

      key-suffix = -> [ ("#{ bit-index + 1 }") for bit, bit-index in bits when bit ] * ''

      #

      get: (x, y) -> Num x ; Num y ; bit-index = index x, y ; return void if bit-index > bits.length ; bits[ bit-index ]
      set: (x, y, bit = on) !-> Num x ; Num y ; Bool bit ; return void if @get[ x, y ] is void ; bits[ (index x, y) ] := bit

      unset: (x, y) !-> @set x, y, off

      clear: -> clear!

      key-suffix: -> key-suffix!

      to-string: -> key = "sextant-#{ key-suffix! }" ; sextant-for-key key

    #

    separated-sextant-char-from-string-list = (strings) ->

      char = new-separated-sextant-char!

      for string, row in strings

        for bit, column in string / ''

          if bit is '*'

            char.set row, column

      char

    {
      new-separated-sextant-char,
      separated-sextant-char-from-string-list
    }