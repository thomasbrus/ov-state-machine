class @PopoverDialog
  constructor: (@$elem, @location, @transit_card, @pubsub)->
    @$scanCardButton = @$elem.find('.button-scan-card')
    @$checkOverButton = @$elem.find('.button-check-over')
    @$selectedCarrier = @$elem.find('select[name=carrier]')

    @$scanCardButton.click => @scanCard()
    @$checkOverButton.click => @checkOver()

    new DelayedButton(@$scanCardButton)
    new DelayedButton(@$checkOverButton)
  
  scanCard: ->
    return false unless @$scanCardButton
    @pubsub.publish '/events/scan_card', {
      carrier_id: @$selectedCarrier.val(),
      location_id: @location.getId()
    }
    
  checkOver: ->
    return false unless @$checkOverButton
    @pubsub.publish '/events/check_over', {
      location_id: @location.getId()
    }
