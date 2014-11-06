gulp = require 'gulp'
jade = require 'gulp-jade'
gutil  = require 'gulp-util'
sass = require 'gulp-sass'
coffee = require 'gulp-coffee'
express = require 'express'
livereload = require 'connect-livereload'
tinylr = require 'tiny-lr'
lr = undefined
# VARIABLES
express_port = 1987
express_root = __dirname + '/output/'
livereload_port = 35729
sources =
	jade: "jade/**/*.jade"
	coffee: "coffee/**/*.coffee"
	sass: "sass/**/*.sass"
	overwatch: "output/**/*.{js,html,css}"
destinations =
	html: "output/"
	js: "output/js/"
	css: "output/css"
gulp.task 'serve', (event) ->
	app = express()
	app.use livereload()
	app.use express.static express_root
	app.listen express_port
	lr = tinylr()
	lr.listen livereload_port
	return
refresh = (event) ->
	fileName = require('path').relative express_root, event.path
	gutil.log.apply gutil, [gutil.colors.magenta(fileName), gutil.colors.cyan('changed')]
	lr.changed body:
		files: [fileName]
gulp.task "jade", (event) ->
	gulp.src("jade/documents/**/*.jade").pipe(jade(pretty: true)).pipe gulp.dest(destinations.html)
gulp.task 'coffee', (event) ->
	gulp.src(sources.coffee).pipe(coffee()).pipe gulp.dest(destinations.js)
gulp.task "sass", (event) ->
	gulp.src(sources.sass).pipe(sass(style: "compressed")).pipe gulp.dest(destinations.css)
gulp.task "watch", ->
	gulp.watch sources.jade, ["jade"]
	gulp.watch sources.sass, ["sass"]
	gulp.watch sources.coffee, ["coffee"]
	gulp.watch sources.overwatch, refresh
	return
gulp.task "default", [
	"serve"
	"jade"
	"coffee"
	"sass"
	"watch"
]
