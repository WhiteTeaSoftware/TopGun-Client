findNew = (newMessages, currentMessages) ->
    message for message in newMessages when message in currentMessages

angular.module 'TGClient.controllers', ['ionic']

.controller 'AppCtrl', ($scope) -> undefined

.controller 'HomeCtrl', ($scope, $ionicPopup, $interval, MessagingService, LoginService, $state) ->
    $scope.data =
        has_new_message: no
    $scope.messages = []
    $scope.refreshInterval = undefined
    $scope.favorites = TGClient.getFavorites()

    MessagingService.getMessages().then (data) ->
        $scope.messages = data

    $scope.isFavorite = (id) ->
        id in (favorite?.id for favorite in $scope.favorites)

    $scope.favNum = (id) ->
        for favorite, i in $scope.favorites
            "fav-message-#{i + 1}" if id is favorite?.id

        'fav-message-0'

    $scope.addToFavorites = (id, author, message) ->
        if $scope.isFavorite id
            for favorite, i in $scope.favorites
                if favorite.id is id
                    delete $scope.favorites[i]
                    TG.updateFavorites $scope.favorites

        else
            for favorite, i in $scope.favorites
                if not favorite?
                    $scope.favorites[i] =
                        id: id
                        author: author
                        message: message

                    TG.updateFavorites[i]


    $scope.postMessage = ->
        if $scope.data.new_message
            MessagingService.postMessage $scope.data.new_message
            $scope.data.new_message = ''
            $scope.refreshMessages()

    $scope.logout = ->
        LoginService.logout()
        if angular.isDefined $scope.refreshInterval
            $interval.cancel $scope.refreshInterval
            $scope.refreshInterval = undefined
        $state.go 'login'

    $scope.refreshMessages = ->
        MessagingService.getMessages().then (data) ->
            if (findNew data, $scope.messages).length > 0
                $scope.messages = data
                $scope.has_new_message = yes

    $scope.gotoFav = (id) -> $state.go 'app.thread', id: id

    $scope.refreshInterval = $interval $scope.refreshMessages, 4000

.controller 'ThreadCtrl', ($scope, LoginService, MessagingService, $stateParams, $state, $interval) ->
    $scope.data = {}
    $scope.responses = []
    $scope.m_id = $stateParams.id
    $scope.refreshInterval = undefined

    $scope.refreshMessage = ->
        MessagingService.getMessage($scope.m_id).then (data) ->
            $scope.data.thread_author = data.n
            $scope.data.thread_message = data.v
            $scope.responses = data.r

    $scope.refreshMessage()

    $scope.postMessage = ->
        if $scope.data.new_message
            MessagingService.postMessage $scope.data.new_message, $scope.m_id
            $scope.data.new_message = ''
            $scope.refreshMessage()

    $scope.logout = ->
        LoginService.logout()
        $interval.cancel $scope.refreshInterval
        $scope.refreshInterval = undefined
        $state.go 'login'

    $scope.gotoMain = -> $state.go 'app.home'

    $scope.itemHeight = -> 30

.controller 'LoginCtrl', ($scope, LoginService, $ionicPopup, $ionicModal) ->
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
                    text: '<b><i class="ion-close"></i></b>'
                    type: 'button-outline button-stable'
                },{
                    text: 'Register'
                    type: 'button-outline button-royal'
                    onTap: (e) ->
                        LoginService.createUser $scope.resisterData.username, $scope.registerData.password, $scope.resisterData.email
                }
            ]

    $scope.doLogin = ->
        LoginService.login $scope.loginData.username, $scope.loginData.password
        .then (success) ->
            $scope.loginForm.error = no
        , (error) ->
            $scope.loginForm.error = yes
