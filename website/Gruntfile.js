module.exports = function (grunt) {
    grunt.initConfig({
        clean: ['build'],

        copy: {
            main: {
                files: [
                    {expand: true, flatten: true, src: ['src/images/*'], dest: 'dist/images/', filter: 'isFile'},
                    {expand: true, flatten: true, src: ['src/seo/*'], dest: 'dist/', filter: 'isFile'}
                ],
            },
        },

        sass: {
            dev: {
                files: {
                    'build/main.css': 'src/sass/main.scss',
                    'build/bootstrap.css': 'node_modules/bootstrap/scss/bootstrap.scss'
                }
            }
        },

        cssmin: {
            build: {
                src: ['build/bootstrap.css', 'build/main.css'],
                dest: 'dist/app.min.css'
            }
        },

        concat: {
            options: {
                separator: '\n/*next file*/\n\n'  //this will be put between conc. files
            },
            dist: {
                src: ['node_modules/jquery/dist/jquery.js',
                    'node_modules/popper.js/dist/umd/popper.js',
                    'node_modules/bootstrap/dist/js/bootstrap.js',
                    'src/js/main.js'],
                dest: 'build/app.js'
            }
        },

        terser: {
            options: {},
            main: {
              files: {
                './dist/app.min.js': ['./build/app.js'],
              }
            }
          },

        htmlbuild: {
          dist: {
            src: ['./src/html/*.html'],
            dest: './build/',
            options: {
              beautify: true,
              relative: true,
              basePath: false,
          sections: {
                layout: {
                  header: './src/templates/header.html',
                  contents: './src/templates/contents.html',
                  navigation: './src/templates/navigation.html',
                  footer: './src/templates/footer.html'
                }
              },
            }
          }
        },

        htmlmin: {
            dist: {
                options: {
                    removeComments: true,
                    collapseWhitespace: true
                },
                files: [{
                    expand: true,
                    cwd: 'build',
                    src: '*.html',
                    dest: 'dist'
                }]
            }
        },

        watch: {
            js: {
                files: 'src/js/*.js',
                tasks: ['js'],
            },
            css: {
                files: 'src/sass/**',
                tasks: ['css'],
            },
            html: {
                files: 'src/html/**',
                tasks: ['htmlbuild', 'htmlmin'],
            }
        }        
    });

    grunt.loadNpmTasks('grunt-contrib-clean');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-sass');
    grunt.loadNpmTasks('grunt-contrib-cssmin');
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-html-build');
    grunt.loadNpmTasks('grunt-contrib-htmlmin');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-terser');

    grunt.registerTask('html', ['clean', 'copy', 'htmlbuild', 'htmlmin']);
    grunt.registerTask('css', ['sass', 'cssmin']);
    grunt.registerTask('js', ['concat', 'terser']);
    grunt.registerTask('default', ['html', 'css', 'js']);
};
