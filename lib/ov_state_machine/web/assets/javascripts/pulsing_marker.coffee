class @PulsingMarker
  constructor: (@$elem) ->
    @$elem.bind 'webkitAnimationEnd', ->
      $(this).removeClass('pulse-success pulse-failure')
