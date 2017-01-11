gulp      = require('gulp')
concat    = require('gulp-concat')
coffee    = require('gulp-coffee')
replace   = require('gulp-replace')
fs        = require('fs')
watchJS   = fs.readFileSync('./vendor/watch.min.js').toString('UTF-8')

gulp.task 'default', ['build', 'watch'], ->

gulp.task 'build', ->
  gulp.src('source/yandex-metrika-embedded.coffee')
    .pipe gulp.dest('build')
    .pipe coffee()
    .pipe replace('/* watch.js */', "try { #{watchJS} } catch (e) {}")
    .pipe gulp.dest('build')

gulp.task 'watch', ->
  gulp.watch 'source/**/*', ['build']
