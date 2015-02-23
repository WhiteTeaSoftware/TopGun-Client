module.exports = ($q, $state, $rootScope) ->
    @settings =
        TGServerUrl: process.env.TG_SERVER__URL ? 'localhost'

    @hostUrl = "http://#{@settings.TGServerUrl}"
    @securityToken = undefined
    @loginType = undefined

    $rootScope.favorites = [undefined, undefined, undefined, undefined, undefined]

    getCurrentLocation = ->
        deferred = $q.defer()
        navigator.geolocation.getCurrentPosition (pos) ->
            deferred.resolve lat: pos.coords.latitude, long: pos.coords.longitude

        deferred.promise

    TG =
        LoginURL: "#{@hostUrl}/login"
        LogoutURL: "#{@hostUrl}/logout"
        CreateUserURL: "#{@hostUrl}/createUser"
        PostMessageURL: "#{@hostUrl}/postMessage"
        GetMessageURL: "#{@hostUrl}/getMessage"
        GetMessagesURL: "#{@hostUrl}/getMessages"
        setLoginType: (t) => @loginType = t
        getLoginType: => @loginType
        setSecurityToken: (t) => @securityToken = t
        getSecurityToken: => @securityToken
        getLatLong: -> getCurrentLocation()
        gotoMessage: (id) -> $state.go 'app.thread', id: id
        favNum: (id) -> if (i = $rootScope.favorites.indexOf id) isnt -1 then i else undefined
        favClear: -> $rootScope.favorites[i] = undefined for i in [0..4]
        favToggle: (id) ->
            if (i = $rootScope.favorites.indexOf id) isnt -1
                $rootScope.favorites[i] = undefined

            else
                for spot, i in $rootScope.favorites
                    if not spot?
                        return $rootScope.favorites[i] = id
