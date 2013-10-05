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

// Sort by match position range (ascending) first, then by average match position (ascending).
function sortMatches(matches) {
  return _(matches).chain().sortBy(function(match) {
    return _.max(match.positions) - _.min(match.positions);
  }).sortBy(function(match) {
    var sum = _.reduce(match.positions, function(a, b) {
      return a + b;
    });
    return sum / match.positions.length;
  }).value();
}

function highlight(string) {
  return '<span class="highlight">' + string + '</span>';
}

// Expose globally
this.fuzzyMatch = fuzzyMatch;
}).call(this);
