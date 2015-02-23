module.exports = ($scope, $interval, LoginService, MessagingService, $stateParams, TG) ->
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
