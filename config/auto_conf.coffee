coffeeScript = require('coffee-script')
nconf        = require("nconf")
pkginfo      = require("pkginfo")(module, "main")
_            = require("underscore")
path         = require("path")
fs           = require("fs")

isRunningAsTestSuite = ->
  
  # if 'main' isn't the application itself, we're usually inside a test runner
  require.main and (require.main.filename isnt path.resolve(exports.main))
detectEnvironment = ->
  # environment is set use it
  return process.env.NODE_ENV if process.env.NODE_ENV
  
  # Otherwise, try to infer environment from invocation method
  if isRunningAsTestSuite()
    "test"
  else
    "development"

getLoadPaths = (type, configDir) ->
  paths = Object.create(null)
  
  # e.g. 'config/settings.defaults.json'
  paths.defaults = path.join(configDir, type + ".defaults.json")
  
  # e.g. ./settings.json
  paths.overrides = path.join(process.cwd(), type + ".json")
  loadPaths = [paths.defaults]

  if fs.existsSync(paths.overrides)
    loadPaths.push paths.overrides
  loadPaths

getConfiguration = (type, currentEnvironment) ->
  config = nconf.stores[type]
  defaults = config.get("defaults")
  environmentOverrides = config.get(currentEnvironment)
  _.extend defaults, environmentOverrides
  defaults

createConfiguration = (type, configDir) ->
  nconf.add type,
    type: "memory"
    loadFrom: getLoadPaths(type, configDir)

  process.env.NODE_ENV = detectEnvironment()  unless process.env.NODE_ENV
  getConfiguration type, process.env.NODE_ENV


exports.createConfiguration = createConfiguration
exports.detectEnvironment = detectEnvironment