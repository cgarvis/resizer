'use strict'

angular.module('fileReader', [])
  .factory 'fileReader', ($q, $log) ->
    onLoad = (reader, deferred, scope) ->
      ->
        scope.$apply ->
          deferred.resolve(reader.result)

    onError = (reader, deferred, scope) ->
      ->
        scope.$apply ->
          deferred.reject(reader.result)

    onProgress = (reader, scope) ->
      (event) ->
        scope.$broadcast("fileProgress", total: event.total, loaded: event.loaded)

    getReader = (deferred, scope) ->
      reader = new FileReader()
      reader.onload = onLoad(reader, deferred, scope)
      reader.onerror = onError(reader, deferred, scope)
      reader.onprogress = onProgress(reader, scope)
      reader

    read: (file, scope) ->
      deferred = $q.defer()

      reader = getReader(deferred, scope)
      reader.readAsDataURL(file)

      deferred.promise


