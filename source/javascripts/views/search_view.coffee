class @SearchView extends Backbone.View
  el: '.search-form'

  events:
    "keydown [name=search]": "onKeyDown"
    "keyup [name=search]": "onKeyUp"
    "focus [name=search]": "renderResults"

  initialize: =>
    @$input = @$el.find("[name=search]")
    @$results = @$el.find(".results")
    @focus()

  onKeyDown: (e) =>
    # Prevent cursor from moving to beginning/end on arrow up/down
    if e.keyCode in [KeyCode.DOWN, KeyCode.UP]
      e.preventDefault()

  onKeyUp: (e) =>
    switch e.keyCode
      when KeyCode.ESCAPE then @handleEscape()
      when KeyCode.DOWN then @moveDown(e)
      when KeyCode.UP then @moveUp(e)
      when KeyCode.ENTER then @goToSelected()
      else @renderResults()

  handleEscape: =>
    if @val()?
      @$input.val("")
      @resetResults()
    else
      @$input.blur()

  moveUp: =>
    console.log("TODO - move up")

  moveDown: =>
    console.log("TODO - move down")

  goToSelected: =>
    console.log("TODO - go to selection")

  goTo: (property) =>
    window.location = "/#{property}/"

  focus: =>
    @$input.focus()
    @renderResults()

  val: =>
    trimmedVal = $.trim(@$input.val())
    if trimmedVal == "" then null else trimmedVal

  resetResults: =>
    @$results.html("")

  renderResults: =>
    @resetResults()

    # TODO - this is a temporary test, store these somewhere else
    terms = ["box-sizing", "box-shadow", "border-radius", "text-shadow", "border-width", "border-left", "border"]

    return unless @val()?
    matches = fuzzyMatch(terms, @val())
    if matches.length > 0
      for match in matches
        $("<a class='result' href='/#{match.match}/'/>")
          .html(match.highlighted).appendTo(@$results)
    else
      @$results.text("No results")
