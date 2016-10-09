initialize = (counterID, options) ->
  unless counterID
    throw new Error('Yandex Metrika initializer: Counter ID is required')

  metrika = null
  create  = -> try metrika = new Ya.Metrika($.extend(id: counterID, options, defer: yes)); return
  hit     = -> metrika?.hit?(location.href.split('#')[0], title: document.title); return

  (window.yandex_metrika_callbacks ?= []).push(create)

  if Turbolinks?.supported
    $(document).on('page:change', hit)
  else
    hit()
    $(document).on('pjax:end', hit) if $.fn.pjax?

  try `// WATCHJS`
  return

if (head = document.getElementsByTagName('head')[0])?
  meta      = head.getElementsByTagName('meta')
  counterID = null
  options   = null

  for el in meta
    switch el.getAttribute('name')
      when 'yandex_metrika:counter_id'
        counterID = el.getAttribute('content')

      when 'yandex_metrika:options'
        json = el.getAttribute('content')
        try options = JSON?.parse(json) or $.parseJSON(json)

  initialize(counterID, options) if counterID