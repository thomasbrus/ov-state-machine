class @Location
  constructor: (@$elem, @transit_card, @pubsub) ->
    @$marker = @$elem.find('.marker')
    @$popOver = @$elem.find('.popover-dialog')  

    @$marker.mouseenter => @showPopover()

    new PopoverDialog(@$popOver, @, @transit_card, @pubsub)

  showPopover: (duration = 'fast') ->
    @$popOver.fadeIn(duration)

  hidePopover: ->
    @$popOver.hide()

  getId: ->
    @$elem.data('location-id')

  getName: ->
    @$elem.data('location-name')
