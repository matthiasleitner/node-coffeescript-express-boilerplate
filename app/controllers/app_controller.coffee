# App Controller
#
#
class AppController
  constructor: (app) ->
    app.get "/", (req, res) ->
      res.send "Hello World"

module.exports = AppController

