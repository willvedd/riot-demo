var gulp = require('gulp'),
    sass = require('gulp-ruby-sass'),
    autoprefixer = require('gulp-autoprefixer'),
    minifycss = require('gulp-minify-css'),
    livereload = require('gulp-livereload');
    rename = require('gulp-rename'),
    concat = require('gulp-concat'),
    uglify = require('gulp-uglify'),
    sourcemaps = require('gulp-sourcemaps');

gulp.task('styles', function() {
	return sass('scss/', { style: 'expanded' })
	    .pipe(gulp.dest('scss'))
	    .pipe(autoprefixer('last 2 version', 'safari 5', 'ie 8', 'ie 9', 'opera 12.1', 'ios 6', 'android 4'))
        .pipe(rename('style.min.css'))
	    .pipe(minifycss())
	    .pipe(gulp.dest('./scss'))
});

gulp.task('scripts', function(){
    return gulp.src(['js/custom/*.js'])
        .pipe(sourcemaps.init())
        .pipe(concat('concat.js'))
        .pipe(gulp.dest('./js'))
        .pipe(rename('main.min.js'))
        .pipe(uglify())
        .pipe(sourcemaps.write('./js'))
        .pipe(gulp.dest('./js'));
});

gulp.task('watch', function() {
  gulp.watch('scss/partials/*.scss', ['styles']);
  gulp.watch('js/custom/*.js', ['scripts']);
});


gulp.task('default', function() {
    gulp.start('styles', 'scripts', 'watch');
});