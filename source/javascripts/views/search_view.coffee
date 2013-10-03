class @SearchView extends Backbone.View
  el: '.search-form'

  events:
    "keydown [name=search]": "onKeyDown"
    "keyup [name=search]": "onKeyUp"
    "focus [name=search]": "renderResults"
    "mouseover .results a": "highlightMouseover"

  initialize: =>
    @$input = @$el.find("[name=search]")
    @$resultsContainer = @$el.find(".results")
    @resetResults()
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
    $selected = @$selectedResult()
    return unless $selected

    if $selected.is(":first-child")
      @selectedIndex = null
    else
      @selectedIndex -= 1
    @highlightSelected()

  moveDown: =>
    $selected = @$selectedResult()
    if $selected
      @selectedIndex += 1 unless $selected.is(":last-child")
    else
      @selectedIndex = 1
    @highlightSelected()

  highlightSelected: =>
    @unhighlightResults()
    @$selectedResult()?.addClass("active")

  highlightMouseover: (e) =>
    @unhighlightResults()
    $selected = $(e.currentTarget)
    $selected.addClass("active")
    @selectedIndex = $selected.index() + 1

  unhighlightResults: =>
    @$results().removeClass("active")

  goToSelected: =>
    $selected = @$selectedResult()
    @goTo($selected.attr("href")) if $selected

  goTo: (property) =>
    window.location.pathname = property

  focus: =>
    @$input.focus()
    @renderResults()

  val: =>
    trimmedVal = $.trim(@$input.val())
    if trimmedVal == "" then null else trimmedVal

  resetResults: =>
    @selectedIndex = null
    @$resultsContainer.html("")

  renderResults: =>
    @resetResults()

    # TODO - this is a temporary test, store these somewhere else
    terms = ["box-sizing", "box-shadow", "border-radius", "text-shadow", "border-width", "border-left", "border"]

    return unless @val()?
    matches = fuzzyMatch(terms, @val())
    if matches.length > 0
      for match in matches
        $("<a class='result' href='/#{match.match}/'/>")
          .html(match.highlighted).appendTo(@$resultsContainer)
    else
      @$resultsContainer.text("No results")

  $results: =>
    @$resultsContainer.find("a")

  $selectedResult: =>
    return unless @selectedIndex
    $selected = @$results().filter(":nth-child(#{@selectedIndex})")
    if $selected.length > 0 then $selected else null
