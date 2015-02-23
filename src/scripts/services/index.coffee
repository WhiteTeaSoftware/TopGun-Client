require 'angular'
require 'ionic/release/js/ionic-angular.js'

angular.module 'TGClient.services', ['ionic']
.factory 'TG', require './TG'
.factory 'MessagingService', require './messaging'
.factory 'LoginService', require './login'
