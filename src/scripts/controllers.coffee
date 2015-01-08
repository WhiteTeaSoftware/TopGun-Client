angular.module 'TGClient.controllers', ['ionic']

.controller 'AppCtrl', ($scope, $state, TG) ->
    $scope.gotoFav = (id) -> TG.gotoMessage $rootScope.favorites[id]

    $scope.logout = ->
        LoginService.logout()
        $state.go 'login'

    if TG.getSecurityToken() is undefined then $state.go 'login'

.controller 'HomeCtrl', ($scope, $ionicPopup, $state, MessagingService, LoginService, TG) ->
    $scope.data = {has_new_message: no}
    $scope.messages = []
    $scope.gotoMessage = TG.gotoMessage

    MessagingService.getMessages().then (data) ->
        $scope.messages = data

    $scope.favNum = (id) -> "fav-message-#{TG.favNum(id)}"

    $scope.favoriteToggle = (id) -> TG.favToggle id

    $scope.postMessage = ->
        if $scope.data.new_message
            MessagingService.postMessage $scope.data.new_message
            $scope.data.new_message = false
            $scope.refreshMessages()

    $scope.refreshMessages = ->
        MessagingService.getMessages().then (data) ->
            delete $scope.messages
            $scope.messages = data
            $scope.$broadcast 'scroll.refreshComplete'

    $scope.refreshMessages()

.controller 'ThreadCtrl', ($scope, $interval, LoginService, MessagingService, $stateParams, TG) ->
    $scope.data = {}
    $scope.responses = []
    $scope.m_id = $stateParams.id

    $scope.refreshMessage = ->
        MessagingService.getMessage($scope.m_id).then (data) ->
            $scope.data.thread_author = data.n
            $scope.data.thread_message = data.v
            $scope.responses = data.r
            $scope.$broadcast 'scroll.refreshComplete'

    $scope.postMessage = ->
        if $scope.data.new_message
            MessagingService.postMessage $scope.data.new_message, $scope.m_id
            $scope.data.new_message = false
            $scope.refreshMessage()

    $scope.refreshMessage()

.controller 'LoginCtrl', ($scope, LoginService, $ionicPopup, $ionicModal, $ionicHistory) ->
    $scope.loginData = {}
    $scope.registerData = {}
    $scope.loginForm = error: no, connError: no
    $scope.modal = $ionicModal.fromTemplate((require '../templates/register.jade'), {scope: $scope})

    $scope.register = ->
        $ionicPopup.show
            template: require '../templates/register.jade'
            title: '<h2><i class="ion-person-add"></i></h2>'
            scope: $scope
            buttons: [
                {
                    text: '<i class="ion-close"></i>'
                    type: 'button-outline button-stable'
                },{
                    text: 'Register'
                    type: 'button-outline button-royal'
                    onTap: (e) ->
                        LoginService.createUser $scope.registerData.username, $scope.registerData.password, $scope.registerData.email
                }
            ]

    $scope.doLogin = ->
        LoginService.login $scope.loginData.username, $scope.loginData.password
        .then (success) ->
            $scope.loginForm.error = no
            $ionicHistory.goBack()
        ,(error) ->
            $scope.loginForm.error = yes
            $ionicHistory.goBack()

    if window.localStorage['rToken']
        r = LoginService.rLogin()
        if r then $ionicHistory.goBack()
