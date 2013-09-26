'use strict'

angular.module('resizer')
  .filter 'human_readable_size', ->
    (size) ->
      templates = ['{{size}} B', '{{size}} KB', '{{size}} MB']
      if size < 1023
        '{{size}} B'.replace('{{size}}', size.toFixed(0))
      else if size < 1048575
        '{{size}} KB'.replace('{{size}}', (size / 1024).toFixed(0))
      else
        '{{size}} MB'.replace '{{size}}', (size / 1024 / 1024).toFixed(0)

  .directive 'resize', ($parse) ->
    restrict: 'A'
    scope:
      expression: '=resize'
      height: '@'
      width: '@'
    link: (scope, element, attrs) ->
      drawImage = ->
        if scope.expression?
          height = parseInt(scope.height, 10)
          width = parseInt(scope.width, 10)

          img = new Image()
          img.src = scope.expression

          context = element[0].getContext('2d')
          context.drawImage(img, 0, 0, width, height)

      scope.$watch('expression+height+width', drawImage, true)

  # Greatest Common Denominator
  .factory 'gcd', ->
    (x, y) ->
      while y isnt 0
        z = x % y
        x = y
        y = z
      x

  .factory 'resizeImage', ($q) ->
    ($scope, image, ratio) ->
      deferred = $q.defer()

      img = new Image()

      img.onload = ->
        $scope.$apply ->
          canvas = document.createElement("canvas")
          ctx = canvas.getContext("2d")

          ctx.width = img.width * ratio
          ctx.height = img.height * ratio

          ctx.drawImage(img, 0, 0, ctx.width, ctx.height)
          dataUrl = canvas.toDataURL()

          deferred.resolve(dataUrl)

      img.src = image

      deferred.promise

  .controller 'MainCtrl', ($scope, fileReader, gcd, resizeImage) ->
    $scope.ratios = [
      {name: '100%', ratio: 1.0}
      {name: '75%', ratio: 0.75}
      {name: '50%', ratio: 0.5}
      {name: '25%', ratio: 0.25}
    ]

    $scope.resize =
      ratio: $scope.ratios[0]
      image: ''

    $scope.$watch 'raw', (raw) ->
      if raw?
        img = new Image()
        img.src = raw.image

        $scope.original = {} unless $scope.original?
        $scope.original.name = raw.name
        $scope.original.image = raw.image
        $scope.original.height = img.height
        $scope.original.width = img.width
        $scope.original.size = raw.size

        common = gcd(Math.abs(img.width), Math.abs(img.height)).toString(10)
        $scope.original.ratio = [img.width / common, img.height / common]

    resize = (ratio) ->
      if ratio? and $scope.original?.image?
        success = (dataUrl) ->
          $scope.resize.image = dataUrl

        fail = (err) ->
          console.log err

        promise = resizeImage($scope, $scope.original.image, ratio)
        promise.then(success, fail)

    $scope.$watch('resize.ratio', resize, true)
