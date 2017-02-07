# Promise.bar

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

Promise.bar works with simultaneous progress bars, and can handle console output - progress bars will always appear
under other `stdout` content.
