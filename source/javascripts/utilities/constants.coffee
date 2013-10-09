@UserInputtableNodes = [
  "INPUT"
  "OPTION"
  "SELECT"
  "TEXTAREA"
]

@VendorPrefixes = [
  'apple' # Alias for WebKit-based browsers
  'atsc' # Advanced Television Standards Committee
  'epub' # EPUB Working Group
  'khtml' # Konqueror browser
  'moz' # Gecko-based browsers
  'ms' # Microsoft
  'o' # Opera
  'wap' # Wireless Application Protocol Forum
  'webkit' # WebKit-based browsers
  'xv' # Opera
]

@VendorPrefixRegex = new RegExp("\-?(#{@VendorPrefixes.join('|')})\-")

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
