class @SoundEffects  
  FAILURE = AudioFX('/sounds/failure.mp3')
  CHECK_IN = AudioFX('/sounds/succesful-check-in.mp3')
  CHECK_OUT = AudioFX('/sounds/succesful-check-out.mp3')

  constructor: (@pubsub) ->
    @pubsub.subscribe "/callbacks/checked_in", -> CHECK_IN.play()
    
    @pubsub.subscribe "/callbacks/checked_over", (data) ->
      (if data.is_checked_in then CHECK_IN else CHECK_OUT).play()
    
    @pubsub.subscribe "/callbacks/checked_out", -> CHECK_OUT.play()
    @pubsub.subscribe "/callbacks/failure", -> FAILURE.play()
