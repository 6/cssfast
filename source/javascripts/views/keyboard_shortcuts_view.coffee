class @KeyboardShortcutsView extends Backbone.View
  el: 'body'
  events:
    'keyup': 'onKeyUp'

  onKeyUp: (e) =>
    # Don't trigger shortcuts when user is typing
    return if e.target.nodeName in UserInputtableNodes

    switch e.keyCode
      when KeyCode.FORWARD_SLASH then searchView.focus()
