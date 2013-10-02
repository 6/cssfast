// Source: http://jsfiddle.net/bulat/CCryL/
function fuzzyMatch(searchSet, query) {
  var tokens = query.toLowerCase().split(''),
    matches = [];
  searchSet.forEach(function(string) {
    var tokenIndex = 0,
      stringIndex = 0,
      matchWithHighlights = '',
      matchedPositions = [];
    string = string.toLowerCase();
    while (stringIndex < string.length) {
      if (string[stringIndex] === tokens[tokenIndex]) {
        matchWithHighlights += highlight(string[stringIndex]);
        matchedPositions.push(stringIndex);
        tokenIndex++;
        if (tokenIndex >= tokens.length) {
          matches.push({
            match: string,
            highlighted: matchWithHighlights + string.slice(stringIndex + 1),
            positions: matchedPositions
          });
          break;
        }
      } else {
        matchWithHighlights += string[stringIndex];
      }
      stringIndex++;
    }
  });
  return matches;
}
