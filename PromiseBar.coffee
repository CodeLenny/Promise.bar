pathval = require "pathval"

###
An individual item to be used with PromiseBar.
###
class Progress

  get = (props) => @::__defineGetter__ name, getter for name, getter of props
  set = (props) => @::__defineSetter__ name, setter for name, setter of props

  ###
  @property {Number} the count of completed items
  ###
  done: 0

  ###
  @param {PromiseBar} bar the parent {PromiseBar}
  @param {Array<Any>} items the items that make up this progress bar.
  @param {Object} _opts options to configure the display of this progress bar.  See `opts` in {PromiseBar#all}.
  ###
  constructor: (@bar, @items, @_opts) ->
    for item in @items
      Promise.resolve(item).then => @tick()

  ###
  Called when one of the Promise items is resolved.
  ###
  tick: ->
    @bar.clear()
    ++@done
    @bar.draw()

  ###
  @property {String} a label for this progress bar.
  @todo (optionally) pad labels to be the same length
  ###
  get label: -> @opt "label"

  ###
  @property {Number} the total number of items.
  ###
  get total: -> @items.length

  ###
  @property {String} the percent of completed items.
  ###
  get percent: ->
    val = if @total > 0 then (100 * (@done / @total)) else 0
    val.toPrecision @opt "percentLength"

  ###
  Find a configuration option by path.
  @param {String} k the path to a configuration option e.g. "categories[1].name"
  @return {Any} the value requested.
  ###
  opt: (k) -> pathval.getPathValue(@_opts, k) ? pathval.getPathValue(@bar.conf, k)

  ###
  The number of lines needed to draw this progress bar.
  @return {Number}
  ###
  lines: -> 1

  ###
  Draws this progress bar to the console.
  @return {String} the formatted progress bar
  ###
  draw: ->
    fn = @opt "format"
    fmt = fn.apply(@, [])
    return fmt if fmt.indexOf(":bar") is -1
    barLength = process.stdout.columns - fmt.replace(':bar', '').length
    filled = if @total > 0 then Math.floor barLength * (@done / @total) else 0
    fill = @opt("filled")[0].repeat filled
    unfilled = @opt("empty")[0].repeat barLength - filled
    console.log fmt.replace(':bar', "#{fill}#{unfilled}")

###
PromiseBar extends `Promise.all()` to display a progress bar representing the state of each item.

Keeps progress bars under all other stdout messages.
When drawing progress bars, a line is left under previous stdout messages, then progress bars are drawn.

```
Listening to 8080.    # Previous stdout message
                      # Empty line
Build: |----------|   # Progress bars
```

The cursor is then moved to the empty line.
When other messages are printed to stdout, they are written to the empty line, leaving the cursor on the first character
of the progress bars.

```
Listening to 8080.
New client connection.
Build: |----------|
```

stdout writes are listened to.  {PromiseBar#clear} is called, which empties all lines of the progress bar.

```
Listening to 8080.
New client connection.

```

The progress bars are then drawn again, with another empty line left for more `process.stdout` messages.

```
Listening to 8080.
New client connection.

Build: |----------|
```
###
class PromiseBar

  Progress: Progress

  ###
  @property {Object} Default options to configure how progress bars are displayed.  See `opts` in  {PromiseBar#all} for
  the properties that can be set.
  ###
  conf: null

  ###
  @property {Boolean} `true` if PromiseBar is in charge of stdout.
  ###
  enabled: no

  ###
  @property {Boolean} `true` if PromiseBar is internally controlling `process.stdout`.
  ###
  processing: no

  constructor: ->
    @conf =
      label: ""
      filled: "▇"
      empty: "-"
      format: ->
        "#{@label} [:bar] #{@done}/#{@total} #{@percent}%"
      percentLength: 3

  ###
  `Promise.all` replacement.
  @param {Array<Any>} items an array of items, same as `Promise.all()`
  @param {Object} opts options to configure the display of the progress bar.  Defaults are set in {ProgressBar#opts}.
  @option opts {String} label text to include in the progress bar.
  @option opts {String} filled a character to use for the solid progress bar.  Defaults to `"▇"`.
  @option opts {String} empty a character to use for unfilled progress.  Defaults to `"-"`.
  @option opts {Function} format a function that returns the string of the progress bar.  See variables in {Progress} to
    insert.  `":bar"` will be replaced with a progress bar filling the available space.
  @option opts {Number} percentLength the number of digits to include for percentages.  Should be above `3`.
  ###
  all: (items, opts={}) ->
    return Promise.all(items) unless @enabled
    @clear()
    @items ?= []
    @items.push new Progress @, items, opts
    @draw()
    Promise.all items

  ###
  Sets up PromiseBar to manage stdout.  Until `enable()` is called, `PromiseBar.all()` acts like `Promise.all()`.
  Can be called multiple times without ill effect.
  @todo redraw on console resize
  ###
  enable: ->
    return if @enabled
    ansi = require "ansi"
    @cursor = ansi process.stdout
    @draw()
    @bufferstdout()
    process.stdout.on "newline", =>
      return if @processing
      @clear()
      @draw()
    process.on "exit", =>
      return unless @items and Array.isArray(@items)
      @processing = yes
      for i in [0..@lines()]
        @cursor.down()
    @enabled = yes

  ###
  Removes all progress bars in stdout.  Assumes that the cursor is on the first line of the progress bars
  (under the blank line).  Returns the cursor to the starting position.
  ###
  clear: ->
    return unless @items and Array.isArray(@items)
    @processing = yes
    for i in [1..@lines()]
      @cursor.eraseLine().down()
    @cursor.up(@lines())
    @processing = no

  ###
  Draw the progress bars to stdout, including a blank line at the start.
  ###
  draw: ->
    return unless @items and Array.isArray(@items)
    @processing = yes
    console.log ""
    for item in @items
      item.draw()
    @cursor.up(@lines() + 1)
    @processing = no

  ###
  The number of lines of stdout that the progress bars take.
  @return {Number}
  ###
  lines: ->
    @items.map((i) -> i.lines()).reduce ((a, b) -> a + b), 0

  ###
  PromiseBar needs stdout to print one line at a time.  Overwrites `process.stdout.write` to write strings that include
  `\n` into multiple writes.
  ###
  bufferstdout: ->
    write = process.stdout.write
    process.stdout.write = (data, args...) =>
      if typeof data isnt "string" or @processing or data.indexOf("\n") is -1
        return write.apply process.stdout, [data, args...]
      lines = data.split("\n")
      if data.slice(-1) is "\n" then lines = lines.slice(0, -1)
      for line in lines
        write.apply process.stdout, ["#{line}\n", args...]

bar = new PromiseBar()

module.exports = bar
