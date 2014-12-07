module.exports = (grunt) ->
    grunt.initConfig
        pkg: grunt.file.readJSON 'package.json'
        browserify:
            dist:
                files:
                    'www/app.js': ['src/scripts/*.coffee']
                options:
                    transform: ['coffeeify', 'debowerify', 'jadeify']

        coffeelint:
            app: ['src/scripts/**/*.coffee']
            options:
                'max_line_length':
                    'level': 'ignore'
                'indentation':
                    'level': 'ignore'
                'no_throwing_strings':
                    'level': 'ignore'

        stylus:
            compile:
                files:
                    'www/app.css': 'src/styles/app.styl'
                options:
                    paths: ['bower_components', 'node_modules', 'src/styles']
                    'include css': yes

        jade:
            compile:
                files:
                    'www/index.html': 'src/templates/app.jade'

        uglify:
            options:
                mangle:
                    false
            my_target:
                files:
                    'www/app.js': ['www/app.js']

        clean: ['www']

    grunt.loadNpmTasks 'grunt-coffeelint'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-stylus'
    grunt.loadNpmTasks 'grunt-contrib-jade'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-browserify'

    grunt.registerTask 'default', ['coffeelint', 'clean', 'browserify','uglify', 'stylus', 'jade']

    return
