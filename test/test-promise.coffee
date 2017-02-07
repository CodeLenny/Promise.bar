chai = require "chai"
should = chai.should()

PromiseBar = require "../PromiseBar"

delay = (t) ->
  new Promise (resolve) ->
    setTimeout resolve, t

describe "PromiseBar.all works like Promise.all", ->

  it "resolves", ->
    Promise.all [
      PromiseBar.all [delay(100)]
      Promise.all [delay(100)]
    ]

  it "works with different data types", ->
    PromiseBar.all [
      10
      delay(100)
    ]
