class @DelayedButton
  BUTTON_ACTIVE_TIMEOUT = 100

  constructor: (@$elem) ->
    @$elem.click =>
      setTimeout((=> @$elem.removeClass('active')), BUTTON_ACTIVE_TIMEOUT)
      @$elem.addClass('active')
