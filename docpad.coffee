# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
docpadConfig = {

	# =================================
	# Template Data
	# These are variables that will be accessible via our templates
	# To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData:

		# Specify some site properties
		site:
			# The production url of our website
			owner: "Lello M. Mascetti"
			url: "http://ar.go:8080"
			email: 'me@email.it'

			# Here are some old site urls that you would like to redirect from
			oldUrls: [
				'www.website.com',
				'website.herokuapp.com'
			]

			# The default title of our website
			title: "Your Website"

			# The website description (for SEO)
			description: """
				When your website appears in search results in say Google, the text here will be shown underneath your website's title.
				"""

			# The website keywords (for SEO) separated by commas
			keywords: """
				place, your, website, keywoards, here, keep, them, related, to, the, content, of, your, website
				"""


		# -----------------------------
		# Helper Functions

		# Get the prepared site/document title
		# Often we would like to specify particular formatting to our page's title
		# we can apply that formatting here
		getPreparedTitle: ->
			# if we have a document title, then we should use that and suffix the site's title onto it
			if @document.title
				"#{@document.title} | #{@site.title}"
			# if our document does not have it's own title, then we should just use the site's title
			else
				@site.title

		# Get the prepared site/document description
		getPreparedDescription: ->
			# if we have a document description, then we should use that, otherwise use the site's description
			@document.description or @site.description

		# Get the prepared site/document keywords
		getPreparedKeywords: ->
			# Merge the document keywords with the site keywords
			@site.keywords.concat(@document.keywords or []).join(', ')

		getGruntedStyles: ->
			_ = require 'underscore'
			styles = []
			siteUrl = @site.url
			gruntConfig = require('./grunt-config.json')
			_.each gruntConfig, (value, key) ->
				styles = styles.concat _.flatten _.pluck value, 'dest'
			styles = _.filter styles, (value) ->
				return value.indexOf('.min.css') > -1
			_.map styles, (value) ->
				#return value.replace 'out', ''
				return value.replace 'out', siteUrl


		getGruntedScripts: ->
			_ = require 'underscore'
			scripts = []
			siteUrl = @site.url
			gruntConfig = require('./grunt-config.json')
			_.each gruntConfig, (value, key) ->
				scripts = scripts.concat _.flatten _.pluck value, 'dest'
			scripts = _.filter scripts, (value) ->
				return value.indexOf('.min.js') > -1
			_.map scripts, (value) ->
				return value.replace 'out', siteUrl

	# =================================
	# Configure Plugins
	# Should contain the plugin short names on the left,
	# and the configuration to pass the plugin on the right
	plugins:
		marked:
			gfm: true

		livereload:
			enabled: true

		sass:
			# enable compass-colors
			# requireLibraries: ['compass-colors']
			# set correct path for the scss
			scssPath: '/usr/bin/scss'
			compass: 'true'

		moment:
			formats: [
				{raw: 'date', format: 'MMMM Do YYYY', formatted: 'humanDate'}
				{raw: 'date', format: 'YYYY-MM-DD', formatted: 'computerDate'}
			]

	# =================================
	# Server Configuration

	# Port
	# Use to change the port that DocPad listens to
	port: 8080

	# =================================
	# Special Custom collections of pages
	collections:
		# Static pages : those for the main menu
		sections: -> @getCollection("html").findAllLive({public: true, relativeOutDirPath: 'sections'}, [orderValue: 1])

		#Blog posts
		posts: -> @getCollection("html").findAllLive({public:true, relativeOutDirPath: 'posts'}, [date: -1])

		# Publications : those in the publications dir
		book: -> @getCollection("html").findAllLive({public:true, relativeOutDirPath: 'publications/book'}, [date: -1])
		journal: -> @getCollection("html").findAllLive({public:true, relativeOutDirPath: 'publications/journal'}, [date: -1])
		conference: -> @getCollection("html").findAllLive({public:true, relativeOutDirPath: 'publications/conf'}, [date: -1])
		demo: -> @getCollection("html").findAllLive({public:true, relativeOutDirPath: 'publications/demo'}, [date: -1])


	# =================================
	# Environment Configuration

	# Locale Code
	# The code we shall use for our locale (e.g. `en`, `fr`, etc)
	# If not set, we will attempt to detect the system's locale, if the locale can't be detected or if our locale file is not found for it, we will revert to `en`
	localeCode: 'en'  # default

	# Environment
	# Which environment we should load up
	# If not set, we will default the `NODE_ENV` environment variable, if that isn't set, we will default to `development`
	#env: development  # default

	# Environments
	# Allows us to set custom configuration for specific environments
	environments:  # default
		development:  # default
			plugins:
				livereload:
					enabled: true

			# Always refresh from server
			maxAge: false  # default
			templateData:
				site:
					url: 'http://ar.go:8080'
		deploy: # change the name here if you have other environments
			maxAge: true
			plugins:
				livereload:
					enabled: false



	# =================================
	# DocPad Events

	# Here we can define handlers for events that DocPad fires
	# You can find a full listing of events on the DocPad Wiki
	events:

		# Server Extend
		# Used to add our own custom routes to the server before the docpad routes are added
		serverExtend: (opts) ->
			# Extract the server from the options
			{server} = opts
			docpad = @docpad

			# As we are now running in an event,
			# ensure we are using the latest copy of the docpad configuraiton
			# and fetch our urls from it
			latestConfig = docpad.getConfig()
			oldUrls = latestConfig.templateData.site.oldUrls or []
			newUrl = latestConfig.templateData.site.url

			# Redirect any requests accessing one of our sites oldUrls to the new site url
			server.use (req,res,next) ->
				if req.headers.host in oldUrls
					res.redirect(newUrl+req.url, 301)
				else
					next()

		# Write After
		# Used to minify our assets with grunt
		writeAfter: (opts,next) ->
			# Prepare
			docpad = @docpad
			rootPath = docpad.config.rootPath
			balUtil = require 'bal-util'
			_ = require 'underscore'

			# Make sure to register a grunt `default` task
			command = ["#{rootPath}/node_modules/.bin/grunt", 'default']

			# Execute
			balUtil.spawn command, {cwd:rootPath,output:true}, ->
				src = []
				gruntConfig = require './grunt-config.json'
				_.each gruntConfig, (value, key) ->
					src = src.concat _.flatten _.pluck value, 'src'
				_.each src, (value) ->
					balUtil.spawn ['rm', value], {cwd:rootPath, output:false}, ->
				balUtil.spawn ['find', '.', '-type', 'd', '-empty', '-exec', 'rmdir', '{}', '\;'], {cwd:rootPath+'/out', output:false}, ->
				next()

			# Chain
			@
}

# Export our DocPad Configuration
module.exports = docpadConfig