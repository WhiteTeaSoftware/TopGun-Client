findNew = (newMessages, currentMessages) ->
    message for message in newMessages when message in currentMessages

hostUrl = 'http://localhost:3000'

angular.module 'TGClient.controllers', ['ionic']

.constant 'LOGIN_URL', "#{hostUrl}/login"
.constant 'LOGOUT_URL', "#{hostUrl}/logout"
.constant 'REGISTER_URL', "#{hostUrl}/createUser"
.constant 'POST_MESSAGE_URL', "#{hostUrl}/postMessage"
.constant 'GET_MESSAGE_URL', "#{hostUrl}/getMessage"
.constant 'GET_MESSAGES_URL', "#{hostUrl}/getMessages"

.controller 'AppCtrl', ($scope) -> ()

.controller 'HomeCtrl', ($scope, $ionicPopup, $interval, MessagingService, LoginService, $state) ->
    $scope.data =
        has_new_message: no
    $scope.messages = []
    $scope.refreshInterval = undefined
    $scope.favorites = TGClient.getFavorites()

    MessagingService.getMessages().then (data) ->
        $scope.messages = data

    $scope.isFavorite = (id) ->
        id in favorite?.id for favorite in $scope.favorites

    $scope.favNum = (id) ->
        for favorite, i in $scope.favorites
            "fav-message-#{i + 1}" if id is favorite?.id

        'fav-message-0'

    $scope.addToFavorites = (id, author, message) ->
        if $scope.isFavorite id
            for favorite, i in $scope.favorites
                if favorite.id is id
                    delete $scope.favorites[i]
                    TGClient.updateFavorites $scope.favorites

        else
            favorite, i in $scope.favorites
                if not favorite?
                    $scope.favorites[i] =
                        id: id
                        author: author
                        message: message

                    TGClient.updateFavorites[i]


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

    $scope.gotoFav = (id) ->
        $state.go 'app.favorite', id: id

    $scope.refreshInterval = $interva; $scope.refreshMessages, 4000
