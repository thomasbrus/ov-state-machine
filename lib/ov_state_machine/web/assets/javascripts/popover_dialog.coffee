class @PopoverDialog
  SOUNDS =
    failure: AudioFX('/sounds/failure.mp3')
    check_in: AudioFX('/sounds/succesful-check-in.mp3')
    check_out: AudioFX('/sounds/succesful-check-out.mp3')

  constructor: (@$elem, @location, @transit_card, @pubsub)->
    @$scanCardButton = @$elem.find('.button-scan-card')
    @$checkOverButton = @$elem.find('.button-check-over')
    @$selectedCarrier = @$elem.find('select[name=carrier]')

    @$scanCardButton.click => @scanCard()
    @$checkOverButton.click => @checkOver()

    new DelayedButton(@$scanCardButton)
    new DelayedButton(@$checkOverButton)

    @pubsub.subscribe "/callbacks/check_in/#{@location.getId()}", (data) =>
      @location.$marker.addClass('pulse-success')
      SOUNDS.check_in.play()

    @pubsub.subscribe "/callbacks/check_out/#{@location.getId()}", (data) =>
      @location.$marker.addClass('pulse-success')
      SOUNDS.check_out.play()

    @pubsub.subscribe "/callbacks/failure/#{@location.getId()}", (data) =>
      @location.$marker.addClass('pulse-failure')
      SOUNDS.failure.play()
  
  scanCard: ->
    return false unless @$scanCardButton
    @pubsub.publish '/events/scan_card', {
      card_id: @transit_card.getId(),
      carrier_id: @$selectedCarrier.val(),
      location_id: @location.getId()
    }
    
  checkOver: ->
    return false unless @$checkOverButton
    @pubsub.publish '/events/check_over', {
      card_id: @transit_card.getId(),
      location_id: @location.getId()
    }
