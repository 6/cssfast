#= stub vendor/jquery
#= require vendor/index
#= require_tree .
#= require_self

$ ->
  window.searchView = new SearchView()
  new KeyboardShortcutsView()
