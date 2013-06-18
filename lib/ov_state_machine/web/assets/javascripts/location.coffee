class @Location
  constructor: (@$elem, @transit_card, @pubsub) ->
    @$marker = @$elem.find('.marker')
    @$popOver = @$elem.find('.popover-dialog')  

    @$marker.mouseenter => @showPopover()

    new PopoverDialog(@$popOver, @, @transit_card, @pubsub)
    new PulsingMarker(@$marker)

    @pubsub.subscribe "/callbacks/check_in/#{@getId()}", (data) =>
      @$marker.addClass('pulse-success')

    @pubsub.subscribe "/callbacks/check_out/#{@getId()}", (data) =>
      @$marker.addClass('pulse-success')

    @pubsub.subscribe "/callbacks/failure/#{@getId()}", (data) =>
      @$marker.addClass('pulse-failure')

  showPopover: (duration = 'fast') ->
    @$popOver.fadeIn(duration)

  hidePopover: ->
    @$popOver.hide()

  getId: ->
    @$elem.data('location-id')

  getName: ->
    @$elem.data('location-name')
