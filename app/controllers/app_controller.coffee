# App Controller
#
#

Pusher = require('node-pusher')
request = require('request')
class AppController

  pusher = new Pusher
    appId: '38441',
    key: '52e8b9204ddcb6462bfc',
    secret: 'e7108058cdfac9f8c288'

  constructor: (app) ->
    app.get "/", (req, res) ->
      res.render "index"

    # send
    app.get "/send", (req, res) =>
      @push "payments", "new_payment",
        amount: 3434234,
        currency: "USD", (err, req, response) =>
          console.log response
          console.log err
          res.send "sent message"

    # pay
    #-------------------------
    app.post "/pay", (req, res) =>
      console.log req.body
      r = request.post("https://api.paymill.com/v2/transactions",
            "auth":
              "user":"9e76b2f6c0121eddaa5f53db6dbdbb8a"
              "pass": " "
            "form":
              "amount":  req.body.amount * 100
              "token": req.body.token
              "description": "happy donating"
              "currency": "EUR"
          ,(e,r, body) =>
            console.log e
            console.log body
            if body
              res.send "Payment sent!"
              push()
          )



  push: (channel, event, data, cb) ->
    pusher.trigger channel, event, data, null, cb




module.exports = AppController

