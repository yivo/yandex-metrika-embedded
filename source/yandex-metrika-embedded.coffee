###!
# yandex-metrika-embedded 1.0.4 | https://github.com/yivo/yandex-metrika-embedded | MIT License
###
  
initialize = (counterID, options) ->
  unless counterID
    throw new TypeError('[Yandex Metrika Initializer] Counter ID is required')

  metrika      = null
  # https://yandex.ru/support/metrika/code/ajax-flash.xml
  init         = -> metrika = new Ya.Metrika($.extend(id: counterID, options, defer: true))
  hit          = -> metrika.hit(hiturl(), hitoptions())
  hiturl       = -> location.href.split('#')[0]
  hitoptions   = -> title: document.title, referrer: document.referrer

  window.yandex_metrika_callbacks = [init, hit]

  if Turbolinks?.supported
    $document  = $(document)
    hitoptions = -> title: document.title, referrer: Turbolinks.referrer
    $document.one 'page:change', -> $document.on('page:change', hit)
  
  watchJS()

watchJS = ->
  try ```
    /* watch.js */
  ```
  return # Explicit return statement

if (head = document.getElementsByTagName('head')[0])?
  meta = head.getElementsByTagName('meta')

  for el in meta
    switch el.getAttribute('name')
      when 'yandex_metrika:counter_id'
        counterID = el.getAttribute('content')

      when 'yandex_metrika:options'
        json = el.getAttribute('content')
        try options = JSON?.parse(json) ? $.parseJSON(json)

  initialize(counterID, options) if counterID
