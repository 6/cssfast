(function() {
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
  return sortMatches(matches);
}

// Sort matches in ascending order of average match positions. This means that
// for "box", "box-shadow" will come before "background-origin-x".
function sortMatches(matches) {
  return _.sortBy(matches, function(match) {
    var sum = _.reduce(match.positions, function(a, b) {
      return a + b;
    });
    return sum / match.positions.length;
  });
}

function highlight(string) {
  return '<span class="highlight">' + string + '</span>';
}

// Expose globally
this.fuzzyMatch = fuzzyMatch;
}).call(this);
