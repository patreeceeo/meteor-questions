$ ->
  if Modernizr.touch
    # cache dom references
    $el = $('body')

    focused = false
    # # bind events
    $(document)
      .on 'focus', 'input, textarea, select', ->
        focused = true
        $el.addClass('u-fixedFix')

      .on 'touchstart', 'input, textarea, select', ->
        _.defer ->
          if focused
            $el.removeClass('u-fixedFix')
