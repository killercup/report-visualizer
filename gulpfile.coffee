gulp = require('gulp')
browserify = require('gulp-browserify')
concat = require('gulp-concat')
uglify = require('gulp-uglify')
sass = require('gulp-sass')
plumber = require('gulp-plumber')

SRC = './src'
DEST = './dist'

PATH =
  scripts: "#{SRC}/app/**/*.coffee"
  scriptsEntry: "#{SRC}/app/index.coffee"
  libsEntry: "#{SRC}/app/libs.coffee"
  styles: "#{SRC}/styles/index.scss"
  static: "#{SRC}/**/*.html"

gulp.task 'scripts', ->
  LIBS = require('./src/app/libs')

  gulp.src(PATH.scriptsEntry, read: false)
  .pipe plumber()
  .pipe browserify
    transform: ['coffeeify']
    extensions: ['.coffee']
    external: LIBS
  .pipe concat('app.js')
  # .pipe uglify
  #   preserveComments: 'some'
  .pipe gulp.dest(DEST)

gulp.task 'scriptLibs', ->
  LIBS = require('./src/app/libs')

  gulp.src(PATH.libsEntry, read: false)
  .pipe browserify
    transform: ['coffeeify']
    extensions: ['.coffee']
    require: LIBS.npmLibs
    shim: LIBS.bowerLibs
  .pipe concat('libs.js')
  # .pipe uglify
  #   preserveComments: 'some'
  .pipe gulp.dest(DEST)

gulp.task 'styles', ->
  gulp.src(PATH.styles)
  .pipe sass()
  .pipe gulp.dest(DEST)

gulp.task 'static', ->
  gulp.src(PATH.static)
  .pipe gulp.dest(DEST)

gulp.task 'watch', ->
  gulp.watch PATH.scripts, ['scripts']
  gulp.watch PATH.libsEntry, ['scriptLibs']
  gulp.watch PATH.styles, ['styles']
  gulp.watch PATH.static, ['static']

gulp.task 'build', ['scripts', 'scriptLibs', 'static', 'styles']
gulp.task 'default', ['build', 'watch']
