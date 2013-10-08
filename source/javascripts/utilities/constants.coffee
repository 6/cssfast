@UserInputtableNodes = [
  "INPUT"
  "OPTION"
  "SELECT"
  "TEXTAREA"
]

@VendorPrefixes = [
  'khtml'
  'moz'
  'ms'
  'o'
  'webkit'
]

@VendorPrefixRegex = new RegExp("\-(#{@VendorPrefixes.join('|')})\-")

@KeyCode =
  BACKSPACE: 8
  COMMA: 188
  DELETE: 46
  DOWN: 40
  END: 35
  ENTER: 13
  ESCAPE: 27
  LEFT: 37
  PAGE_DOWN: 34
  PAGE_UP: 33
  PERIOD: 190
  RIGHT: 39
  SPACE: 32
  TAB: 9
  UP: 38
  FORWARD_SLASH: 191
  BACK_SLASH: 220
