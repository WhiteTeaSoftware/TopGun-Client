moment = require 'moment'

module.exports = ($q, $http, $ionicPopup, $filter, TG) ->
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
