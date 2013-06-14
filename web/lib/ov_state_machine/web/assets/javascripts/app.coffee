$ ->

  $map = $('.map')
  $markers = $('.marker')
  $popOvers = $('.popover-small, .popover-large')
  $buttons = $('.button-yellow, .button-green')

  $markers.mouseenter ->
    $popOvers.css(display: 'none')
    $(this).find('.actions').css(display: 'block')

  $buttons.click ->
    $(this).addClass('active')
    setTimeout((=> $popOvers.css(display: 'none')), 100)

  $buttons.mouseleave ->
    $(this).removeClass('active')    