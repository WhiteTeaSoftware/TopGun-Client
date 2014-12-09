require 'ionic'
require 'angular'
require 'angular-animate'
require 'angular-sanitize'
require 'angular-ui-router'
require 'ionic/js/ionic-angular.js'

window.app = angular.module 'TGClient', ['ionic', 'TGClient.controllers', 'TGClient.services']

.run ($rootScope, $state, $ionicPlatform, $window) ->
    $ionicPlatform.ready ->
        cordiva.plugins.Keyboard.hideKeyboardAccessoryBar on if window.cordova?.plugins?.Keyboard
        StatusBar.styleDefault() if window.StatusBar

.config ($stateProvider, $urlRouterProvider) ->
    $stateProvider.state 'app',
        url: '/app'
        abstract: yes
        template: require '../templates/menu.jade'
        controller: 'AppCtrl'

    .state 'login',
        url: '/login'
        template: require '../templates/login.jade'
        controller: 'LoginCtrl'

    .state 'app.home',
        url: '/home'
        views:
            menuContent:
                template: require '../templates/home.jade'
                controller: 'HomeCtrl'

    .state 'app.thread',
        url: '/thread/:id'
        views:
            menuContent:
                template: require '../templates/thread.jade'
                controller: 'ThreadCtrl'

    $urlRouterProvider.otherwise '/login'
