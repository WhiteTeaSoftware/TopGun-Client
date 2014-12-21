module.exports = (grunt) ->
    grunt.initConfig
        pkg: grunt.file.readJSON 'package.json'
        browserify:
            dist:
                files:
                    'www/app.js': ['src/scripts/*.coffee']
                options:
                    transform: ['coffeeify', 'debowerify', 'browserify-plain-jade']

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
            target:
                files:
                    'www/app.js': ['www/app.js']

        cssmin:
            target:
                files:
                    'www/app.css': ['www/app.css']

        cordovacli:
            options:
                path: 'www'
            add_plugins:
                options:
                    command: 'plugin'
                    action: 'add'
                    plugins: [
                        'org.apache.cordova.device'
                        'org.apache.cordova.geolocation'
                        'org.apache.cordova.inappbrowser'
                        'com.ionic.keyboard'
                    ]

        copy:
            main:
                files: [
                    {
                        expand: yes
                        cwd: 'src/assets'
                        src: ['**']
                        dest: 'www/'
                    },{
                        expand: yes
                        cwd: 'bower_components/ionic/release/fonts'
                        src: ['*']
                        dest: 'www/fonts/'
                    }
                ]

        clean: ['www/*.*']

    grunt.loadNpmTasks 'grunt-coffeelint'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-stylus'
    grunt.loadNpmTasks 'grunt-contrib-jade'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-contrib-cssmin'
    grunt.loadNpmTasks 'grunt-browserify'
    grunt.loadNpmTasks 'grunt-cordovacli'

    grunt.registerTask 'default', ['coffeelint', 'clean', 'browserify', 'stylus', 'jade', 'uglify', 'cssmin', 'copy', 'cordovacli']
    grunt.registerTask 'build', ['clean', 'browserify', 'stylus', 'jade']

    return
