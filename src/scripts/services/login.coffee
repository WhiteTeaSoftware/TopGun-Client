module.exports = ($q, $http, $state, $ionicLoading, TG) ->
    commitLogout = ->
        TG.favClear()
        TG.setSecurityToken undefined
        TG.setLoginType undefined

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
                loginPromise.resolve data
                TG.setSecurityToken data.t
                TG.setLoginType 'n'
            .error ->
                loginPromise.reject()

            loginPromise.promise

        rLogin: ->
            loginPromise = $q.defer()

            $http
                url: TG.LoginURL
                method: 'POST'
                data: JSON.stringify r: window.localStorage['rToken']
                headers: 'Content-Type': 'application/json'
            .success (data) ->
                loginPromise.resolve data
                window.localStorage['rToken'] = data.r
                TG.setSecurityToken data.t
                TG.setLoginType 'n'
            .error ->
                loginPromise.reject()

            loginPromise.promise

        createUser: (username, password, email) ->
            userPromise = $q.defer()
            $http
                url: TG.CreateUserURL
                method: 'POST'
                data: JSON.stringify u: username, p: password , e: email
                headers: 'Content-Type': 'application/json'
            .success (data) ->
                userPromise.resolve data
            .error ->
                userPromise.reject()

            userPromise.promise()
