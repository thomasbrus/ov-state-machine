class @PopoverDialog
  BUTTON_ACTIVE_TIMEOUT = 100

  constructor: (@$elem, @location, @transit_card)->
    @$scanCardButton = @$elem.find('.button-scan-card')
    @$checkOverButton = @$elem.find('.button-check-over')

    @$scanCardButton.click => @scanCard()
    @$checkOverButton.click => @checkOver()

    $.each [@$scanCardButton, @$checkOverButton], (_, elem) =>
      $(elem).click =>
        setTimeout((=>
          $(elem).removeClass('active')
          # @$elem.hide()
        ), BUTTON_ACTIVE_TIMEOUT)

        $(elem).addClass('active')
  
  scanCard: ->
    return false unless @$scanCardButton
    console.log 'Scanning card...'

    # For test purposes only...
    switch @location.getId()
      when 50
        @transit_card.animateLastCheckedIn(@location.getName())
        @transit_card.animateCurrentCarrier('Syntus')      
      # when 51
        # @transit_card.animateLastCheckedIn('—')
        # @transit_card.animateCurrentCarrier('—')
        # @transit_card.animateBalance('3.75')
      when 52
        @transit_card.animateLastCheckedIn('—')
        @transit_card.animateCurrentCarrier('—')
        @transit_card.animateBalance(@transit_card.getBalance() - 1.75)
    
  checkOver: ->
    return false unless @$checkOverButton
    console.log 'Checking over...'

    # For test purposes only...
    switch @location.getId()
      when 51
        @transit_card.animateLastCheckedIn('Hengelo')
        @transit_card.animateCurrentCarrier('TLS')
        @transit_card.animateBalance(@transit_card.getBalance() - 1.45)