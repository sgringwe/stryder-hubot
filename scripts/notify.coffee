# Description
#   Listens for any chat message and notifies scott, garrett, ben
#
# Dependencies:
#   "jsdom": "~0.2.13"
#
# Configuration:
#   None
#
# Commands:
#   {chat message} - Messages people
#
# Notes:
#
#
# Author:
#   sgringwe

# jsdom = require 'jsdom'
HTTP = require "http"
QS = require "querystring"

module.exports = (robot) ->
  sid   = process.env.HUBOT_SMS_SID
  token = process.env.HUBOT_SMS_TOKEN
  from  = process.env.HUBOT_SMS_FROM

  send_message = =>
    auth = new Buffer(sid + ':' + token).toString("base64")
    data = QS.stringify From: from, To: "+12314925380", Body: message

    robot.http("https://api.twilio.com")
      .path("/2010-04-01/Accounts/#{@sid}/Messages.json")
      .header("Authorization", "Basic #{auth}")
      .header("Content-Type", "application/x-www-form-urlencoded")
      .post(data) (err, res, body) ->
        if err
          console.log err
        else if res.statusCode is 201
          # json = JSON.parse(body)
          # callback null, body
          console.log body
        else
          # json = JSON.parse(body)
          # callback body.message
          console.log body

  robot.hear /.+/, (msg) ->
    # robot.http('http://beastmode.fm/track/' + msg.match[2])
    #   .get() (err, res, body) ->
    #     jsdom.env body, [jquery], (errors, window) ->
    #       trackImg    = window.$('#track-img img').attr('src')
    #       trackTitle  = window.$('#article-info h1').text()
    #       msg.send trackTitle + ' ' + trackImg
    send_message()