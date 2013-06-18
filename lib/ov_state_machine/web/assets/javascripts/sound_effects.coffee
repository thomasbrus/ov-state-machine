class @SoundEffects  
  FAILURE = AudioFX('/sounds/vendor/failure.mp3')
  CHECK_IN = AudioFX('/sounds/vendor/succesful-check-in.mp3')
  CHECK_OUT = AudioFX('/sounds/vendor/succesful-check-out.mp3')

  constructor: (@pubsub) ->
    @pubsub.subscribe "/callbacks/check_in/*", -> CHECK_IN.play()
    @pubsub.subscribe "/callbacks/check_out/*", -> CHECK_OUT.play()
    @pubsub.subscribe "/callbacks/failure/*", -> FAILURE.play()
