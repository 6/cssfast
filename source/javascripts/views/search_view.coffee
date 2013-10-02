class @SearchView extends Backbone.View
  el: '.search-form'

  events:
    "keyup [name=search]": "renderResults"

  initialize: =>
    @$searchInput = @$el.find("[name=search]")
    @$searchInput.focus()
    @$results = @$el.find(".results")

  renderResults: =>
    @$results.html("")

    # TODO - this is a temporary test, store these somewhere else
    terms = ["box-sizing", "box-shadow", "border-radius", "text-shadow", "border-width", "border-left", "border"]

    query = $.trim(@$searchInput.val())
    matches = fuzzyMatch(terms, query)
    if matches.length > 0
      for match in matches
        $('<li/>').html(match.highlighted).appendTo(@$results)
    else
      @$results.text("No results")
