module.exports = (grunt) ->
    grunt.initConfig
        pkg: grunt.file.readJSON 'package.json'
        browserify:
            dist:
                files:
                    'www/app.js': ['src/scripts/app.coffee']
                options:
                    transform: ['coffeeify', 'debowerify', 'browserify-plain-jade']
                    browserifyOptions:
                        extensions: ['.coffee']

        coffeelint:
            dist: ['src/scripts/**/*.coffee']
            options:
                'max_line_length':
                    'level': 'ignore'
                'indentation':
                    'level': 'ignore'
                'no_throwing_strings':
                    'level': 'ignore'

        stylus:
            dist:
                files:
                    'www/app.css': 'src/styles/app.styl'
                options:
                    paths: ['bower_components', 'node_modules', 'src/styles']
                    'include css': yes

        jade:
            dist:
                files:
                    'www/index.html': 'src/templates/app.jade'

        uglify:
            dist:
                files:
                    'www/app.js': ['www/app.js']
                options:
                    mangle: no

        cssmin:
            dist:
                files:
                    'www/app.css': ['www/app.css']

        cordovacli:
            options:
                path: 'www'
            dist:
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
            dist:
                files: [
                    {
                        expand: yes
                        cwd: 'resources'
                        src: ['**']
                        dest: 'www/'
                    },{
                        expand: yes
                        cwd: 'bower_components/ionic/release/fonts'
                        src: ['*']
                        dest: 'www/fonts/'
                    }
                ]

        clean:
            dist: ['www/*.*']

    grunt.loadNpmTasks 'grunt-coffeelint'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-stylus'
    grunt.loadNpmTasks 'grunt-contrib-jade'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-contrib-cssmin'
    grunt.loadNpmTasks 'grunt-browserify'
    grunt.loadNpmTasks 'grunt-cordovacli'

    grunt.registerTask 'build', ['coffeelint', 'clean:dist', 'browserify', 'stylus', 'jade']
    grunt.registerTask 'minify', ['uglify', 'cssmin']
    grunt.registerTask 'dist', ['build', 'minify', 'copy']
    grunt.registerTask 'default', ['build', 'minify', 'copy', 'cordovacli']

    return
