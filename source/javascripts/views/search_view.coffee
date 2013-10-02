class @SearchView extends Backbone.View
  el: '.search-form'

  events:
    "keydown [name=search]": "onKeyDown"
    "keyup [name=search]": "onKeyUp"
    "click .result": "goToClicked"

  initialize: =>
    @$searchInput = @$el.find("[name=search]")
    @$searchInput.focus()
    @$results = @$el.find(".results")

  onKeyDown: (e) =>
    # Prevent cursor from moving to beginning/end on arrow up/down
    if e.keyCode in [KeyCode.DOWN, KeyCode.UP]
      e.preventDefault()

  onKeyUp: (e) =>
    switch e.keyCode
      when KeyCode.DOWN then @moveDown(e)
      when KeyCode.UP then @moveUp(e)
      when KeyCode.ENTER then @goToSelected()
      else @renderResults()

  moveUp: =>
    console.log("TODO - move up")

  moveDown: =>
    console.log("TODO - move down")

  goToSelected: =>
    console.log("TODO - go to selection")

  goToClicked: (e) =>
    @goTo($(e.currentTarget).data('property'))

  goTo: (property) =>
    window.location = "/#{property}/"

  renderResults: =>
    @$results.html("")

    # TODO - this is a temporary test, store these somewhere else
    terms = ["box-sizing", "box-shadow", "border-radius", "text-shadow", "border-width", "border-left", "border"]

    query = $.trim(@$searchInput.val())
    matches = fuzzyMatch(terms, query)
    if matches.length > 0
      for match in matches
        $("<li class='result' data-property='#{match.match}'/>")
          .html(match.highlighted).appendTo(@$results)
    else
      @$results.text("No results")
