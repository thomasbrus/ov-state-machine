$ ->
  pubsub = new Faye.Client('http://localhost:9191/pubsub')
  transit_card = new TransitCard($('#transit_card'), pubsub)

  locations = [
    new Location($('#railway-station-delden'), transit_card, pubsub)
    new Location($('#railway-station-hengelo'), transit_card, pubsub)
    new Location($('#railway-station-enschede-drienerlo'), transit_card, pubsub)
  ]

  locations[1].showPopover('normal')
  $('#legend, #transit_card').hide().fadeIn()

  # TODO: Improve this
  $.each locations, (_, location) ->
    this.$marker.mouseenter ->
      $.each locations, -> this.hidePopover() unless this == location