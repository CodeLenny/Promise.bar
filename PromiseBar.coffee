###
An individual item to be used with PromiseBar.
###
class Progress

  constructor: (@promisebar, @items, opts) ->

###
PromiseBar extends `Promise.all()` to display a progress bar representing the state of each item.
###
class PromiseBar

  Progress: Progress

  enabled: no

  enable: ->
    @enabled = yes

  all: (items, opts={}) ->
    return Promise.all(items) unless @enabled
    @items ?= []
    @items.push new Progress @, items, opts
    Promise.all items

bar = new PromiseBar()

module.exports = bar
