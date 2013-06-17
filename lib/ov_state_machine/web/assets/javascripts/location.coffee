class @Location
  constructor: (@$elem, @transit_card) ->
    @$marker = @$elem.find('.marker')
    @$popOver = @$elem.find('.popover-dialog')  

    @$marker.mouseenter => @showPopover()
    # @$popOver.mouseleave => @hidePopover()

    new PopoverDialog(@$popOver, @, @transit_card)

  showPopover: (duration = 'fast') ->
    @$popOver.fadeIn(duration)

  hidePopover: ->
    @$popOver.hide()

  getId: ->
    @$elem.data('location-id')

  getName: ->
    @$elem.data('location-name')

