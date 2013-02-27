# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#new_history')
    .on 'ajax:complete', (event, ajax, status) ->
      response = $.parseJSON(ajax.responseText)
      html = response.html

      # 領域を書き換え
      $('#history_form').append html
      $('#latest_history').css('display', 'none')
    .on 'ajax:error', (event) ->
      $('#history_form').append "エラー"