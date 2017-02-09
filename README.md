# Promise.bar

## Usage

Doing a bunch of tasks asynchronously with promises, and want a status indicator?

```javascript
let files = ["a.coffee", "b.coffee"];
let minifies = [];
for(const file of files) {
  let compile = compile(file);
  let minify = compile.then(minify);
  minifies.push(minify);
}
Promise.all(minifies).then(() -> {
  console.log("Compile Done!");
});
```

Simply replace `Promise.all` with `PromiseBar.all`, and watch a progress bar fill as compilations finish!

```javascript
let PromiseBar = require("promisebar");
PromiseBar.enable();

PromiseBar.all(minifies, {label: "Minify"}).then(() -> {
  console.log("Compile Done!");
});
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

Promise.bar supports much more customization than the options listed here.  Please check out the full API documentation
for other configurable options.

[Chalk]: https://github.com/chalk/chalk
