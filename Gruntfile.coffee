fs = require('fs')

module.exports = (grunt) ->
  # Add a top-level safety wrapper around JS to prevent context/scope leakage
  wrapJS = (js) ->
    "(function() { #{js} }).call(this);"

  grunt.registerTask 'cssProperties', ->
    properties = []
    for property,prefixes of JSON.parse(grunt.file.read('css-properties/css-prefixes.json'))
      properties.push(property)
    propertiesJS = wrapJS("window.cssProperties = #{JSON.stringify(properties)};")
    fs.writeFileSync('source/javascripts/build/properties.js', propertiesJS, 'utf-8', {flags: 'w+'})

  grunt.registerTask('default', ['cssProperties'])

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
