module.exports = ($scope, LoginService, $ionicPopup, $ionicModal, $ionicHistory) ->
    $scope.loginData = {}
    $scope.registerData = {}
    $scope.loginForm = error: no, connError: no
    $scope.modal = $ionicModal.fromTemplate((require '../../templates/register.jade'), {scope: $scope})

    $scope.register = ->
        $ionicPopup.show
            template: require '../../templates/register.jade'
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

    if window.localStorage['rToken']
        r = LoginService.rLogin()
        if r then $ionicHistory.goBack()
