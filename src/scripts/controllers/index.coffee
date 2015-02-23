require 'angular'
require 'ionic/release/js/ionic-angular.js'

angular.module 'TGClient.controllers', ['ionic']
.controller 'AppCtrl', require './app'
.controller 'HomeCtrl', require './home'
.controller 'LoginCtrl', require './login'
.controller 'ThreadCtrl', require './thread'
