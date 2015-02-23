module.exports = ($scope, $ionicPopup, $state, MessagingService, LoginService, TG) ->
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
            $scope.data.new_message = ''
            $scope.refreshMessages()

    $scope.refreshMessages = ->
        MessagingService.getMessages().then (data) ->
            delete $scope.messages
            $scope.messages = data
            $scope.$broadcast 'scroll.refreshComplete'

    $scope.refreshMessages()
