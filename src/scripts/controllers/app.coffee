module.exports = ($scope, $state, TG) ->
    $scope.gotoFav = (id) -> TG.gotoMessage $rootScope.favorites[id]

    $scope.logout = ->
        LoginService.logout()
        $state.go 'login'

    if TG.getSecurityToken() is undefined then $state.go 'login'
