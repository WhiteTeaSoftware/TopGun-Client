module.exports = (grunt) ->
    grunt.initConfig
        pkg: grunt.file.readJSON 'package.json'
        browserify:
            dist:
                files:
                    'www/app.js': ['src/scripts/app.coffee']
                options:
                    transform: ['coffeeify', 'debowerify']
                    
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
                    'include css': true
                    
        jade:
            compile:
                files:
                    'www/index.html': 'src/templates/index.jade'
                    
        clean: ['www']
        
    grunt.loadNpmTasks 'grunt-coffeelint'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-stylus'
    grunt.loadNpmTasks 'grunt-contrib-jade'
    grunt.loadNpmTasks 'grunt-browserify'
    
    grunt.registerTask 'default', ['coffeelint', 'clean', 'browserify', 'stylus', 'jade']
    
    return