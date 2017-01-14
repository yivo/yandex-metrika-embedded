###!
# yandex-metrika-embedded 1.0.2 | https://github.com/yivo/yandex-metrika-embedded | MIT License
###
  
initialize = (counterID, options) ->
  unless counterID
    throw new TypeError('[Yandex Metrika Initializer] Counter ID is required')

  metrika = null
  create  = -> try metrika = new Ya.Metrika($.extend(id: counterID, options, defer: true)); return
  hit     = -> metrika?.hit?(location.href.split('#')[0], title: document.title); return
    
  (window.yandex_metrika_callbacks ?= []).push(create)

  if Turbolinks?.supported
    $(document).on('page:change', hit)
  else
    hit()
    $(document).on('pjax:end', hit) if $.support.pjax

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
        try options = JSON?.parse(json) or $.parseJSON(json)

  initialize(counterID, options) if counterID
