gulp       = require 'gulp'
concat     = require 'gulp-concat'
coffee     = require 'gulp-coffee'
iife       = require 'gulp-iife-wrap'
plumber    = require 'gulp-plumber'

gulp.task 'default', ['build'], ->

gulp.task 'build', ->
  gulp.src('source/callbacks.coffee')
    .pipe plumber()
    .pipe iife(global: 'Callbacks')
    .pipe concat('callbacks.coffee')
    .pipe gulp.dest('build')
    .pipe coffee()
    .pipe concat('callbacks.js')
    .pipe gulp.dest('build')
