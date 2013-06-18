class @PopoverDialog
  BUTTON_ACTIVE_TIMEOUT = 100
  PULSE_ACTIVE_TIMEOUT = 1000
  SOUNDS =
    failure: AudioFX('/sounds/failure.mp3')
    check_in: AudioFX('/sounds/succesful-check-in.mp3')
    check_out: AudioFX('/sounds/succesful-check-out.mp3')

  constructor: (@$elem, @location, @transit_card)->
    @$scanCardButton = @$elem.find('.button-scan-card')
    @$checkOverButton = @$elem.find('.button-check-over')

    @$scanCardButton.click => @scanCard()
    @$checkOverButton.click => @checkOver()

    $.each [@$scanCardButton, @$checkOverButton], (_, elem) =>
      $(elem).click =>
        $(elem).addClass('active')

        setTimeout((=>
          $(elem).removeClass('active')
        ), BUTTON_ACTIVE_TIMEOUT)
        
        $(elem).closest('.marker').addClass('pulse-success')

    @$elem.closest('.marker').bind 'webkitAnimationEnd', ->
      $(this).removeClass('pulse-success pulse-failure')

  scanCard: ->
    return false unless @$scanCardButton
    console.log 'Scanning card...'

    # For test purposes only...
    switch @location.getId()
      when 50
        @transit_card.animateLastCheckedIn(@location.getName())
        @transit_card.animateCurrentCarrier('Syntus')
        SOUNDS.check_in.play()
      when 51
        # @transit_card.animateLastCheckedIn('—')
        # @transit_card.animateCurrentCarrier('—')
        # @transit_card.animateBalance('3.75')
        SOUNDS.failure.play()
      when 52
        @transit_card.animateLastCheckedIn('—')
        @transit_card.animateCurrentCarrier('—')
        @transit_card.animateBalance(@transit_card.getBalance() - 1.75)
        SOUNDS.check_out.play()
    
  checkOver: ->
    return false unless @$checkOverButton
    console.log 'Checking over...'

    # For test purposes only...
    switch @location.getId()
      when 51
        @transit_card.animateLastCheckedIn('Hengelo')
        @transit_card.animateCurrentCarrier('TLS')
        @transit_card.animateBalance(@transit_card.getBalance() - 1.45)
        SOUNDS.check_in.play()