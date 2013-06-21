class @DelayedButton
  DEACTIVATE_DELAY = 100

  constructor: (@$elem) ->
    @$elem.click => @activateButton()
    @$elem.click => setTimeout((=> @deactivateButton()), DEACTIVATE_DELAY)

  activateButton: ->
    @$elem.addClass('active')

  deactivateButton: ->
    @$elem.removeClass('active')
