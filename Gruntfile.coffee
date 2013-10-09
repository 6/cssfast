fs = require('fs')
glob = require('glob')

module.exports = (grunt) ->
  # Add a top-level safety wrapper around JS to prevent context/scope leakage
  wrapJS = (js) ->
    "(function() { #{js} }).call(this);"

  cssProperties = ->
    JSON.parse(grunt.file.read('css-properties/css-prefixes.json'))

  cssDescriptions = ->
    JSON.parse(grunt.file.read('hacktionary/css-properties.json'))

  grunt.registerTask 'cssPropertiesJS', ->
    properties = []
    for property,prefixes of cssProperties()
      properties.push(property)
    propertiesJS = wrapJS("window.cssProperties = #{JSON.stringify(properties)};")
    fs.writeFileSync('source/javascripts/build/properties.js', propertiesJS, 'utf-8', {flags: 'w+'})

  grunt.registerTask 'cssPropertiesHTML', ->
    descriptions = cssDescriptions()
    for property,prefixes of cssProperties()
      continue unless descriptions[property]?
      html = """
      ---
      title: #{property}
      ---
      <h1 class='property-title'>#{property}</h1>
      <p class='property-description'>#{descriptions[property]}</p>
      """
      fs.writeFileSync("source/#{property}.erb", html, 'utf-8', {flags: 'w+'})

  grunt.registerTask 'removeGeneratedHTML', ->
    for path in glob.sync('source/*.erb')
      fs.unlinkSync(path)

  grunt.registerTask('default', ['removeGeneratedHTML', 'cssPropertiesJS', 'cssPropertiesHTML'])

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
