fs = require('fs')
glob = require('glob')
yaml = require('js-yaml')
_ = require('underscore')

module.exports = (grunt) ->
  # Add a top-level safety wrapper around JS to prevent context/scope leakage
  wrapJS = (js) ->
    "(function() { #{js} }).call(this);"

  camelize = (str) ->
    String(str).replace /\-([a-z])/g, (match, submatch) ->
      submatch.toUpperCase()

  removeHtmlTags = (tag, str) ->
    pattern = new RegExp("<#{tag}\\b[^>]*>(.*?)<\\/#{tag}>", "ig")
    String(str).replace pattern, (match, submatch) ->
      submatch

  createOrMergeData = (property, data) ->
    dataPath = "data/#{property}.yml"
    # Don't overwrite existing data
    if fs.existsSync(dataPath)
      existingData = yaml.load(grunt.file.read(dataPath))
      data = _.extend(data, existingData)
    data = yaml.dump(data, {indent: 2})
    fs.writeFileSync(dataPath, data, 'utf-8', {flags: 'w+'})

  vendorCssProperties = ->
    JSON.parse(grunt.file.read('css-properties/css-prefixes.json'))

  vendorCssDescriptions = ->
    JSON.parse(grunt.file.read('hacktionary/css-properties.json'))

  cssData = ->
    data = {}
    for filePath in glob.sync('data/*.yml')
      propertyData = yaml.load(grunt.file.read(filePath))
      data[propertyData.name] = propertyData
    data

  grunt.registerTask 'cssPropertiesJS', ->
    properties = Object.keys(cssData()).sort()
    propertiesJS = wrapJS("window.cssProperties = #{JSON.stringify(properties)};")
    fs.writeFileSync('source/javascripts/build/properties.js', propertiesJS, 'utf-8', {flags: 'w+'})

  grunt.registerTask 'cssPropertiesHTML', ->
    # TODO - encapsulate CSS property data in a class
    for property,data of cssData()
      description = if data.description_html != '' then data.description_html else data.description_plain

      pageData = {
        title: "CSS #{property} property"
        description: data.description_plain
      }

      # TODO - extract this into an external template file
      html = """
      ---\n#{yaml.dump(pageData)}---
      <h1 class='property-title'>#{property}</h1>
      <p class='property-description'>#{description}</p>
      <div class='edit-link-container'>[<a href='https://github.com/6/cssfast/blob/master/data/#{property}.yml'>Edit on GitHub</a>]</div>
      """
      if data.related?.length > 0
        html += "<h2 class='section-header'>Related properties</h2><ul class='related-properties'>"
        for related in data.related
          html += "<li><a href='/#{related}/'>#{related}</a></li>"
        html += "</ul>"

      fs.writeFileSync("source/#{property}.erb", html, 'utf-8', {flags: 'w+'})

  grunt.registerTask 'removeGeneratedHTML', ->
    for path in glob.sync('source/*.erb')
      fs.unlinkSync(path)

  grunt.registerTask 'bootstrapCssData', ->
    descriptions = vendorCssDescriptions()
    for property,prefixes of vendorCssProperties()
      description = descriptions[property] || ""
      description_html = removeHtmlTags('a', description)
      # MDN descriptions only have <a> and <code> tags
      description_plain = removeHtmlTags('code', description_html).replace(/\n/g, "")
      createOrMergeData(property, {
        name: property
        description_plain: description_plain
        description_html: description_html
        javascript_property_name: camelize(property)
      })

  grunt.registerTask('default', ['removeGeneratedHTML', 'cssPropertiesJS', 'cssPropertiesHTML'])

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
