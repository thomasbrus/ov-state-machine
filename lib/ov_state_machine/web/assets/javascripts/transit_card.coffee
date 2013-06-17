class @TransitCard
  DIGIT_ANIMATION_OPTIONS = duration: 500, easing: 'swing'
  FLIP_DURATION = 250

  constructor: (@$elem) ->
    @$digits = @$elem.find('.balance > span')
    @$lastCheckedIn = @$elem.find('.checked-in-at > p')
    @$currentCarrier = @$elem.find('.current-carrier > p')

    $.each [@$lastCheckedIn, @$currentCarrier], ->
      $(this).css transition: "#{FLIP_DURATION / 1000}s"

  setBalance: (balance) ->
    formattedBalance = parseFloat(balance).toFixed(2)

    if formattedBalance < 0
      @$digits.parent().addClass('insufficient-funds')
    else
      @$digits.parent().removeClass('insufficient-funds')

    @$digits.text(formattedBalance.replace('.', ','))

  getBalance: ->
    parseFloat(@$digits.text().replace(',', '.'))

  animateBalance: (balance) ->
    $(value: @getBalance()).animate {value: balance},
      $.extend DIGIT_ANIMATION_OPTIONS, {
        step: (value) => @setBalance(value)
      }

  setCheckedInAt: (location) ->
    @$lastCheckedIn.text(location)
  
  getCheckedInAt: ->
    location = @$lastCheckedIn.text()
  
  animateCheckedInAt: (location) ->
    return if location == @getCheckedInAt()

    @$lastCheckedIn.addClass('flipped')
    setTimeout (=>
      @setCheckedInAt(location)  
      @$lastCheckedIn.removeClass('flipped')
    ), FLIP_DURATION
  
  setCurrentCarrier: (carrier) ->
    @$currentCarrier.text(carrier)

  getCurrentCarrier: ->
    @$currentCarrier.text()

  animateCurrentCarrier: (carrier) ->
    return if carrier == @getCurrentCarrier()

    @$currentCarrier.toggleClass('flipped')
    setTimeout (=>
      @setCurrentCarrier(carrier)
      @$currentCarrier.removeClass('flipped')
    ), FLIP_DURATION

