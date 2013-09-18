'use strict'

angular.module('imageDrop', ['fileReader'])
  .directive 'imageDrop', ($parse, fileReader) ->
    restrict: 'EA'
    link: (scope, element, attrs) ->
      expression = attrs.imageDrop
      accessor = $parse(expression)

      loadFile = (file) ->
        fileReader.read(file, scope)

      element.bind "dragover", (e) ->
        e.preventDefault()
        element.addClass("drag_over")
        element.removeClass("not_drag_over")

      element.bind "dragleave", (e) ->
        e.preventDefault()
        element.removeClass("drag_over")
        element.addClass("not_drag_over")

      element.bind "drop", (e) ->
        e.preventDefault()
        element.removeClass("drag_over")
        element.removeClass("not_drag_over")

        file = e.dataTransfer.files[0]
        loadFile(file)
          .then (result) ->
            file.image = result
            accessor.assign(scope, file)
