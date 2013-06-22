class @DelayedButton
  DEACTIVATE_DELAY = 100

  constructor: (@$elem) ->
    @$elem.click => @activate()
    @$elem.click => setTimeout((=> @deactivate()), DEACTIVATE_DELAY)

  activate: ->
    @$elem.addClass('active')

  deactivate: ->
    @$elem.removeClass('active')
