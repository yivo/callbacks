gulp    = require 'gulp'
concat  = require 'gulp-concat'
coffee  = require 'gulp-coffee'
umd     = require 'gulp-umd-wrap'
plumber = require 'gulp-plumber'
fs      = require 'fs'

gulp.task 'default', ['build'], ->

gulp.task 'build', ->
  gulp.src('source/pub-sub-callback-api.coffee')
    .pipe plumber()
    .pipe umd(global: 'Callbacks', header: fs.readFileSync('source/__license__.coffee'))
    .pipe concat('pub-sub-callback-api.coffee')
    .pipe gulp.dest('build')
    .pipe coffee()
    .pipe concat('pub-sub-callback-api.js')
    .pipe gulp.dest('build')
