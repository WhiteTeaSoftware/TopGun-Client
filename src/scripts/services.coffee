moment = require 'moment'

hostUrl = 'http://localhost:80'

angular.module 'TGClient.services', ['ionic']

.factory 'TG', ($q, $state) ->
    @securityToken = null
    @loginType = null

    getCurrentLocation = ->
        deferred = $q.defer()
        navigator.geolocation.getCurrentPosition (pos) ->
            deferred.resolve lat: pos.coords.latitude, long: pos.coords.longitude

        deferred.promise

    TG =
        LoginURL: "#{hostUrl}/login"
        LogoutURL: "#{hostUrl}/logout"
        CreateUserURL: "#{hostUrl}/createUser"
        PostMessageURL: "#{hostUrl}/postMessage"
        GetMessageURL: "#{hostUrl}/getMessage"
        GetMessagesURL: "#{hostUrl}/getMessages"
        favorites: new Array(5)
        setLoginType: (t) => @loginType = t
        getLoginType: => @loginType
        setSecurityToken: (t) => @securityToken = t
        getSecurityToken: => @securityToken
        getLatLong: -> getCurrentLocation()
        gotoMessage: (id) -> $state.go 'app.thread', id: id
        toggleFav: (id) ->
            if (i = @favorites.indexOf id) isnt -1
                console.log "Deleting #{i}"
                delete @favorites[i]
            else
                for spot, i in @favorites
                    if not spot?
                        console.log "Setting #{i}"
                        @favorites[i] = id
                        return console.log @favorites

                console.log "Set nothing..."

        gotoFav: (num) ->
            gotoMessage @favorites[num]

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

        getMessage: (id) ->
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

            dataPromise.promise

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

            dataPromise.promise

.factory 'LoginService', ($q, $http, $state, $ionicLoading, TG) ->
    commitLogout = ->
        TG.updateFavorites undefined
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
                loginPromise.resolve()
                TG.setSecurityToken data.t
                TG.setLoginType 'n'
                $state.go 'app.home'
            .error ->
                loginPromise.reject()

        createUser: (username, password, email) ->
            $http
                url: TG.CreateUserURL
                method: 'POST'
                data: JSON.stringify u: username, p: password , e: email
                headers: 'Content-Type': 'application/json'
