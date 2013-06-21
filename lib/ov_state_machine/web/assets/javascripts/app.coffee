$ ->
  pubsub = new Faye.Client('http://localhost:9191/pubsub')
  transit_card = new TransitCard($('#transit_card'), pubsub)

  locations = [
    new Location($('#railway-station-delden'), pubsub)
    new Location($('#railway-station-hengelo'), pubsub)
    new Location($('#railway-station-enschede-drienerlo'), pubsub)
  ]

  new SoundEffects(pubsub)
  new PageController(locations)
