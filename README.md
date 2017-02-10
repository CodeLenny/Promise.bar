# Promise.bar

<div align="center">
  <img src="https://cloud.githubusercontent.com/assets/9272847/22797422/28f948ba-eecc-11e6-82de-e6c283528b6a.png">
</div>

[![Promise.bar on NPM](https://img.shields.io/npm/v/promise.bar.svg)](https://www.npmjs.com/package/promise.bar)

## Usage

Doing a bunch of tasks asynchronously with promises, and want a status indicator?

```javascript
let compiles = [
  compile("a.coffee"),
  compile("b.coffee")
];
Promise.all(compiles).then(() => {
  console.log("Compile Done!");
});
```

Simply replace `Promise.all` with `PromiseBar.all`, and watch a progress bar fill as compilations finish!

```javascript
let PromiseBar = require("promise.bar");
PromiseBar.enable();

PromiseBar.all(compiles, {label: "Minify"}).then(() -> {
  console.log("Compile Done!");
});
```

(Install PromiseBar via `npm install --save promise.bar`)

### Alias as `Promise.bar`

Make PromiseBar even cuter.

```javascript
Promise.bar = function() {
  return PromiseBar.all(arguments);
};
```

### Stacked Progress Bars

Want to stack progress bars?

```javascript
child = PromiseBar.all([], {label: "Child"});
parent = PromiseBar.all([child], {label: "Parent"});
```

The child will automatically be indented under the parent.  Disable this for a progress bar by passing `flat: false` to
`PromiseBar#all`, or disable it for all progress bars with `PromiseBar.conf.flat = false;`.

### Color the Progress Bar

Add colors to your progress bars with libraries like [Chalk][].

```javascript
let chalk = require("chalk");

PromiseBar.all([], {label: chalk.blue("Progress"), barFormat: chalk.dim.blue});
```

The label will be colored blue, and the progress bar will be light blue.  You can provide any function to `barFormat`
to transform the output.

### Always Below `console.log` Content

Progress bars will always appear under other `stdout` content.

### All Options

Promise.bar supports much more customization than the options listed here.  Please check out the
[full API documentation][PromiseBar#all] for other configurable options.

[Chalk]: https://github.com/chalk/chalk
[PromiseBar#all]: https://promisebar.codelenny.com/#https://promisebar.codelenny.com/class/PromiseBar.html#all-dynamic
