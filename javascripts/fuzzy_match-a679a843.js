function fuzzyMatch(h,t){var e=t.toLowerCase().split(""),i=[];return h.forEach(function(h){var t=0,o=0,r="",s=[];for(h=h.toLowerCase();o<h.length;){if(h[o]===e[t]){if(r+=highlight(h[o]),s.push(o),t++,t>=e.length){i.push({match:h,highlighted:r+h.slice(o+1),positions:s});break}}else r+=h[o];o++}}),i}