_     = require('underscore')
_.str = require('underscore.string')
fs    = require('fs')
path  = require('path')



load = (app, folder) ->
  app[folder] = requireFiles path.join("../app/",folder)
  
requireFiles = (folder) ->

  object = {}
  files = fs.readdirSync path.join(__dirname, folder)

  files.forEach (fileName) ->
    
    # skip folder ref and hidden files
    return if _.str.startsWith(fileName, ".")
    
    # remove file extension
    className = fileName.replace(/\.js/, "").replace(/\.coffee/, "")

    # create actual class name
    className = _.str.camelize(className)
    className = _.str.capitalize(className)

    object[className] = require path.join(__dirname, folder, fileName)

    console.log "required: #{className} from #{folder}"

  object


module.exports = load: load