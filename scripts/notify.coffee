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
  console.log 'Starting notification services via twilio'
  @sid   = process.env.HUBOT_SMS_SID
  @token = process.env.HUBOT_SMS_TOKEN
  @from  = process.env.HUBOT_SMS_FROM

  @last_message = 0;

  send_message = =>
    auth = new Buffer(@sid + ':' + @token).toString("base64")
    data = QS.stringify From: @from, To: "+12314925380", Body: "You have a new message on stryder support"

    @last_message = new Date();
    robot.http("https://api.twilio.com")
      .path("/2010-04-01/Accounts/#{@sid}/Messages.json")
      .header("Authorization", "Basic #{auth}")
      .header("Content-Type", "application/x-www-form-urlencoded")
      .post(data) (err, res, body) ->
        if err
          console.log err
        else if res.statusCode is 201
          console.log body
        else
          console.log body

  robot.hear /.+/, (msg) ->
    now = new Date()
    console.log @last_message
    console.log now
    diff = now - (@last_message || 0)
    console.log "Diff is #{diff}"
    minutes_since_last = Math.floor(diff / 1000 / 60);

    console.log "Diff is #{minutes_since_last} minutes"
    if minutes_since_last > 15
      send_message()
    else
      console.log "Not sending message as it has not been 15 minutes since the last"