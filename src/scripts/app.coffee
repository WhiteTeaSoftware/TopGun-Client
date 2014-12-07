require 'ionic'
require 'angular'
require 'angular-animate'
require 'angular-sanitize'
require 'angular-ui-router'
require 'ionic/release/js/ionic-angular.js'

angular.module 'TGClient', ['ionic', 'TGClient.controllers', 'TGClient.services']

.run ($rootScope, $state, $ionicPlatform, $window) ->
    $ionicPlatform.ready ->
        cordiva.plugins.Keyboard.hideKeyboardAccessoryBar on if window.cordova?.plugins?.Keyboard
        StatusBar.styleDefault() if window.StatusBar

.config ($stateProvider, $urlRouterProvider) ->
    $stateProvider

    .state 'app',
        url: 'app'
        abstract: yes
        templateUrl: require '../templates/menu.jade'
        controller: 'AppCtrl'

    .state 'app.home',
        url: '/home'
        views:
            menuContent:
                templateUrl: require '../templates/home.jade'
                controller: 'HomeCtrl'

    .state 'app.login',
        url: '/login'
        templateUrl: require '../templates/login.jade'
        controller: 'LoginCtrl'

    .state 'app.favorite',
        url: '/favorite/:id'
        views:
            menuContent:
                templateUrl: require '../templates/favorite.jade'
                controller: 'FavoriteCtrl'

    $urlRouterProvider.otherwise '/login'
