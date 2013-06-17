$ ->
  transit_card = new TransitCard($('#transit_card'))

  locations = [
    new Location($('#railway-station-delden'), transit_card)
    new Location($('#railway-station-hengelo'), transit_card)
    new Location($('#railway-station-enschede-drienerlo'), transit_card)
  ]

  locations[1].showPopover('normal')
  $('#legend, #transit_card').hide().fadeIn()

  $.each locations, (_, location) ->
    this.$marker.mouseenter ->
      $.each locations, ->
        unless this == location
          this.hidePopover()

  # setTimeout (=>
  #   transit_card.animateBalance(-2.00)
  #   transit_card.animateLastCheckedIn('Enschede-Drienerlo')
  #   transit_card.animateCurrentCarrier('NS')
  # ), 1000
