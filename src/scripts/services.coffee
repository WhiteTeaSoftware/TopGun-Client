hostUrl = 'http://localhost:3000'

angular.module 'TGClient.services', ['ionic']

.factory 'TG', ($q) ->
    @securityToken = null
    @loginType = null
    @favorites = new Array(5)

    getCurrentLocation = ->
        deferred = $q.defer()
        navigator.geolocation.getCurrentPosition (pos) ->
            deferred.resolve lat: pos.coords.latitude, long: pos.coords.longitude

        deferred.promise

    TG =
        updateFavorites: (f) => @favorites = f
        getFavorites: => @favorites
        setLoginType: (t) => @loginType = t
        getLoginType: => @loginType
        setSecurityToken: (t) => @securityToken = t
        getSecurityToken: => @securityToken
        getLatLong: -> getCurrentLocation()
        LoginURL: "#{hostUrl}/login"
        LogoutURL: "#{hostUrl}/logout"
        CreateUserURL: "#{hostUrl}/createUser"
        PostMessageURL: "#{hostUrl}/postMessage"
        GetMessageURL: "#{hostUrl}/getMessage"
        GetMessagesURL: "#{hostUrl}/get. /Messages"

.factory 'MessagingService', ($q, $http, $ionicPopup, $filter, TG) ->
    MessagingService =
        postMessage: (message, id) ->
            if id?
                $http
                    url: TG.PostMessageURL
                    method: 'POST'
                    data: JSON.stringify r: id, t: TG.getSecurityToken(), v: message
                    headers: 'Content-Type': 'application/json'
            else
                TG.getLatLong().then (data) ->
                    $http
                        url: TG.PostMessageURL
                        method: 'POST'
                        data: JSON.stringify t: TG.getSecurityToken(), v: message, l: [data.long, data.lat]
                        headers: 'Content-Type': 'application/json'

        getMessage: ->
            dataPromise = $q.defer()
            $http
                url: TG.GetMessageURL
                method: 'POST'
                data: JSON.stringify _id: id
                headers: 'Content-Type': 'application/json'
            .success (data) ->
                dataPromise.resolve data
            .error ->
                dataPromise.reject()

            dataPromise

        getMessages: ->
            dataPromise = $q.defer()
            TG.getLatLong().then (data) ->
                $http
                    url: TG.GetMessagesURL
                    method: 'POST'
                    data: JSON.stringify l: [data.long, data.lat], s: moment().subtract(30, 'minutes').format 'MMMM d, y HH:mm:ss'
                    headers: 'Content-Type': 'application/json'
                .success (data) ->
                    dataPromise.resolve data
                .error ->
                    dataPromise.reject()

            dataPromise

.factory 'LoginService', ($q, $http, $state, $ionicLoading, TG) ->
    commitLogout = ->
        TG.setSecurityToken ''
        TG.setLoginType ''

    LoginService =
        logout: ->
            $http
                url: TG.LogoutURL
                method: 'POST'
                data: JSON.stringify t: TG.getSecurityToken()
                headers: 'Content-Type': 'application/json'
            .success ->
                commitLogout()
            .error ->
                commitLogout()

        login: (username, password) ->
            loginPromise = $q.defer()

            $http
                url: TG.LoginURL
                method: 'POST'
                data: JSON.stringify u: username, p: password
                headers: 'Content-Type': 'application/json'
            .success (data) ->
                loginPromsie.resolve()
                TG.setSecurityToken data.t
                TG.setLoginType 'n'
                $state.go 'app.home'
            .error ->
                loginPromise.reject()

        createUser: (username, password, email) ->
            $http
                url: TG.CreateUserURL
                method: 'POST'
                data: JSON.stringify u: username, p: passowrd , e: email
                headers: 'Content-Type': 'application/json'
