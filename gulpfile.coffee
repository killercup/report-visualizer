gulp = require('gulp')
browserify = require('gulp-browserify')
concat = require('gulp-concat')
uglify = require('gulp-uglify')
sass = require('gulp-sass')
plumber = require('gulp-plumber')
coffeelint = require('gulp-coffeelint')

SRC = './src'
DEST = './dist'

PATH =
  scripts: "#{SRC}/app/**/*.coffee"
  scriptsEntry: "#{SRC}/app/index.coffee"
  libsEntry: "#{SRC}/app/libs.coffee"
  styles: "#{SRC}/styles/**/*.scss"
  stylesEntry: "#{SRC}/styles/index.scss"
  static: "#{SRC}/**/*.html"

gulp.task 'lint', ->
  gulp.src(PATH.scripts)
  .pipe plumber()
  .pipe coffeelint()
  .pipe coffeelint.reporter()

gulp.task 'scripts', ['lint'], ->
  LIBS = require('./src/app/libs')

  gulp.src(PATH.scriptsEntry, read: false)
  .pipe plumber()
  .pipe browserify
    transform: ['coffeeify']
    extensions: ['.coffee']
    external: LIBS
  .pipe concat('app.js')
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
  .pipe gulp.dest(DEST)

gulp.task 'styles', ->
  gulp.src(PATH.stylesEntry)
  .pipe plumber()
  .pipe sass()
  .pipe gulp.dest(DEST)

gulp.task 'static', ->
  gulp.src(PATH.static)
  .pipe plumber()
  .pipe gulp.dest(DEST)

gulp.task 'minify', ['scripts', 'scriptLibs'], ->
  gulp.src "#{DEST}/*.js"
  .pipe uglify
    preserveComments: 'some'
  .pipe gulp.dest(DEST)

gulp.task 'watch', ->
  gulp.watch PATH.scripts, ['scripts']
  gulp.watch PATH.libsEntry, ['scriptLibs']
  gulp.watch PATH.styles, ['styles']
  gulp.watch PATH.static, ['static']

gulp.task 'build', ['scripts', 'scriptLibs', 'static', 'styles']
gulp.task 'default', ['build', 'watch']
gulp.task 'compile', ['static', 'styles', 'minify']
