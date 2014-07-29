module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    clean:
      jade: ['partials/']
      less: ['css/']
      coffee: ['js/']

    jade:
      options:
        pretty: true
      files:
        expand: true
        cwd: 'src/jade/'
        src: '**/*.jade'
        dest: './'
        ext: '.html'
 
    less:
      options:
        compress: false
      files:
        expand: true
        cwd: 'src/less/'
        src: '**/*.less'
        dest: './css/'
        ext: '.css'

    coffee:
      compile:
        expand: true
        flatten: false
        cwd: 'src/coffee/'
        src: '**/*.coffee'
        dest: './js/'
        ext: '.js'

    watch:
      jade: 
        files: ['src/jade/**/*.jade']
        tasks: ['clean:jade', 'jade']
      less: 
        files: ['src/less/**/*.less']
        tasks: ['clean:less', 'less']
      coffee:
        files: ['src/coffee/**/*.coffee']
        tasks: ['clean:coffee', 'coffee']

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['clean', 'jade', 'less', 'coffee', 'watch']