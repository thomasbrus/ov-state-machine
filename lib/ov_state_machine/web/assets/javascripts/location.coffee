class @Location
  constructor: (@$elem, @pubsub) ->
    @$marker = @$elem.find('.marker')
    @$popOver = @$elem.find('.popover-dialog')

    @$marker.mouseenter => @showPopover()

    new PopoverDialog(@$popOver, @, @pubsub)
    new PulsingMarker(@$marker)

    @pubsub.subscribe "/callbacks/checked_in", (data) =>
      if data.location_id == @getId()
        @$marker.addClass('pulse-success')

    @pubsub.subscribe "/callbacks/checked_over", (data) =>
      if data.location_id == @getId()
        @$marker.addClass('pulse-success')

    @pubsub.subscribe "/callbacks/checked_out", (data) =>
      if data.location_id == @getId()
        @$marker.addClass('pulse-success')

    @pubsub.subscribe "/callbacks/failure", (data) =>
      if data.location_id == @getId()
        @$marker.addClass('pulse-failure')

  showPopover: (options) ->
    options = $.extend { duration: 'fast' }, options
    @$popOver.fadeIn(options['duration'])

  hidePopover: (options) ->
    options = $.extend { duration: 0 }, options
    @$popOver.fadeOut(options['duration'])

  getId: ->
    @$elem.data('location-id')

  getName: ->
    @$elem.data('location-name')
