flour = require "flour"
{exec} = require "child-process-promise"

task "build", "Build compiled source code", (opts) ->
  compile "PromiseBar.coffee", "PromiseBar.js"

###
Before:
```sh
git clone git@github.com:CodeLenny/Promise.bar.git gh-pages
```

On first commit:
```sh
cd gh-pages
# git config commit.gpgsign true
git checkout --orphan gh-pages
```
###
task "docs", "Build gh-pages", (opts) ->
  exec "cd gh-pages; git checkout master; git branch -d gh-pages; git fetch; git checkout origin/gh-pages -b gh-pages"
    .then ->
      exec "$(npm bin)/codo --output gh-pages PromiseBar.coffee - README.md"
    .then ->
      exec "cd gh-pages; git add *; git commit -am 'Updated documentation.'; git push origin gh-pages"
    .catch (err) ->
      console.log err
      throw err
