class @PageController
  constructor: (@locations) ->
    # Fade in page elements
    @locations[1].showPopover(duration: 'normal')
    $('#legend, #transit_card').hide().fadeIn()

    $.each @locations, (_, location) =>
      # Hide other popovers on hover except this one
      location.$marker.mouseenter => @hidePopovers(except: location)

  hidePopovers: (options) ->
    options = $.extend { except: [] }, options
    $(@locations).not($(options['except'])).each -> this.hidePopover()
