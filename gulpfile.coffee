require('gulp-lazyload')
  gulp:       'gulp'
  connect:    'gulp-connect'
  concat:     'gulp-concat'
  coffee:     'gulp-coffee'
  preprocess: 'gulp-preprocess'
  iife:       'gulp-iife'
  uglify:     'gulp-uglify'
  rename:     'gulp-rename'
  del:        'del'
  plumber:    'gulp-plumber'
  replace:    'gulp-replace'

gulp.task 'default', ['build', 'watch'], ->

dependencies = [
  {require: 'lodash'}
  {require: 'yess', global: '_'}
  {require: 'publisher-subscriber'}
]

gulp.task 'build', ->
  gulp.src('source/callbacks.coffee')
  .pipe plumber()
  .pipe preprocess()
  .pipe iife {global: 'Callbacks', dependencies}
  .pipe concat('callbacks.coffee')
  .pipe replace(/CALLBACKS/g, "'_4'")
  .pipe replace(/INITIALIZERS/g, "'_5'")
  .pipe gulp.dest('build')
  .pipe coffee()
  .pipe concat('callbacks.js')
  .pipe gulp.dest('build')

gulp.task 'build-min', ['build'], ->
  gulp.src('build/callbacks.js')
  .pipe uglify()
  .pipe rename('callbacks.min.js')
  .pipe gulp.dest('build')

gulp.task 'watch', ->
  gulp.watch 'source/**/*', ['build']
