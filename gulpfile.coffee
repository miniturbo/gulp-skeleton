path       = require 'path'
gulp       = require 'gulp'
gulpif     = require 'gulp-if'
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

production = process.env.NODE_ENV is 'production'

npmPackages = -> Object.keys require('./package.json').dependencies

errorHandler = ->
  notify
    .onError
      title   : 'Error'
      message : '<%= error.message %>'
    .apply this, [].slice.call(arguments)
  this.emit 'end'

gulp.task 'js', ->
  browserify './public/src/js/app.js'
    .transform 'coffeeify'
    .external npmPackages()
    .bundle()
    .on('error', errorHandler)
    .pipe source('app.js')
    .pipe buffer()
    .pipe gulpif(production, uglify())
    .pipe gulp.dest('./public/js')

gulp.task 'js:vendor', ->
  browserify()
    .require npmPackages()
    .bundle()
    .on('error', errorHandler)
    .pipe source('vendor.js')
    .pipe buffer()
    .pipe gulpif(production, uglify())
    .pipe gulp.dest('./public/js')

gulp.task 'css', ->
  paths = bowerFiles.ext('scss').files.map (file) -> path.dirname(file)
  gulp
    .src './public/src/scss/**/*.scss'
    .pipe plumber(errorHandler: errorHandler)
    .pipe sass(includePaths: paths)
    .pipe gulpif(production, minifyCSS())
    .pipe gulp.dest('./public/css')

gulp.task 'watch', ['build'], ->
  tasks =
    './public/src/**/*.coffee'     : ['js']
    './public/src/**/*.js'         : ['js']
    './public/src/**/*.scss'       : ['css']
    './bower_components/**/*.scss' : ['css']
    './gulpfile.coffee'            : ['build']
  npmPackages().forEach (key) -> tasks["./node_modules/#{key}/**/*.js"] = ['js:vendor']
  Object.keys(tasks).forEach (key) -> gulp.watch key, tasks[key]

gulp.task 'build', ['js', 'js:vendor', 'css']
gulp.task 'default', ['build']
