require 'angular/angular.min.js'
require 'angular-ui-router/release/angular-ui-router.min.js'
require 'ionic/release/js/ionic.min.js'

angular.module 'TGClient', ['ionic', 'TGClient.controllers', 'TGClient.directives', 'TGClient.services']

.run ($rootScope, $state, $ionicPlatform, $window) ->
    $ionicPlatform.ready ->
        cordiva.plugins.Keyboard.hideKeyboardAccessoryBar on if window.cordova?.plugins?.Keyboard
        StatusBar.styleDefault() if window.StatusBar
        
.config ($stateProvider, $urlRouterProvider) ->
    $stateProvider
    
    .state 'app',
        url: 'app'
        abstract: yes
        templateUrl: 'templates/menu.html'
        controller: 'AppCtrl'
        
    .state 'app.home',
        url: '/home'
        views:
            menuContent:
                templateUrl: 'templates/home.html'
                controller: 'HomeCtrl'
                
    .state 'app.login',
        url: '/login'
        templateUrl: 'templates/login.html'
        controller: 'LoginCtrl'
        
    .state 'app.favorite',
        url: '/favorite/:id'
        views:
            menuContent:
                templateUrl: 'templates/favorite.html'
                controller: 'FavoriteCtrl'
                
    $urlRouterProvider.otherwise '/login'