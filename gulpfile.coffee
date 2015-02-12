path       = require 'path'
gulp       = require 'gulp'
gutil      = require 'gulp-util'
sass       = require 'gulp-sass'
plumber    = require 'gulp-plumber'
notify     = require 'gulp-notify'
concat     = require 'gulp-concat'
uglify     = require 'gulp-uglify'
debug      = require 'gulp-debug'
minifyCSS  = require 'gulp-minify-css'
bowerFiles = require('bower-files')(camelCase: false)
source     = require 'vinyl-source-stream'
buffer     = require 'vinyl-buffer'
browserify = require 'browserify'

errorHandler = ->
  notify
    .onError
      title   : 'Error'
      message : '<%= error.message %>'
    .apply this, [].slice.call(arguments)
  this.emit 'end'

gulp.task 'js', ->
  deps = bowerFiles.ext('js').deps
  browserify './public/src/js/app.js'
    .transform 'coffeeify'
    .external Object.keys(deps)
    .bundle()
    .on('error', errorHandler)
    .pipe source('app.js')
    .pipe buffer()
    .pipe uglify()
    .pipe gulp.dest('./public/js')

gulp.task 'js:vendor', ->
  deps  = bowerFiles.ext('js').deps
  files = Object.keys(deps)
    .map    (key)  -> deps[key].map (file) -> { file: file, expose: key }
    .reduce (a, b) -> a.concat(b)

  browserify()
    .require files
    .bundle()
    .on('error', errorHandler)
    .pipe source('vendor.js')
    .pipe buffer()
    .pipe uglify()
    .pipe gulp.dest('./public/js')

gulp.task 'css', ->
  paths = bowerFiles.ext('scss').files.map (file) -> path.dirname(file)
  gulp
    .src './public/src/scss/**/*.scss'
    .pipe plumber(errorHandler: errorHandler)
    .pipe sass(includePaths: paths)
    .pipe minifyCSS()
    .pipe gulp.dest('./public/css')

gulp.task 'watch', ['build'], ->
  gulp.watch './public/src/**/*.coffee', ['js']
  gulp.watch './public/src/**/*.js', ['js']
  gulp.watch './public/src/**/*.scss', ['css']
  gulp.watch './bower_components/**/*.js', ['js:vendor']

gulp.task 'build', ['js', 'js:vendor', 'css']
gulp.task 'default', ['build']
