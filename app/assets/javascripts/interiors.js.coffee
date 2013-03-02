# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#new_history')
    .on 'ajax:complete', (event, ajax, status) ->
      response = $.parseJSON(ajax.responseText)
      html = response.html

      # 領域を書き換え
      $('#history_form').html html
      $('#latest_history').css('display', 'none')
    .on 'ajax:error', (event) ->
      $('#history_form').append "エラー"

  $('#edit_history')
    .on 'ajax:complete', (event, ajax, status) ->
      response = $.parseJSON(ajax.responseText)
      html = response.html

      # フォームの置き換え
      $('#history_form').html html
      $('#latest_history').css('display', 'none')
    .on 'ajax:error', (event) ->
      $('#history_form').append "エラー"

  $('#history_form')
    .on 'ajax:complete', (event, ajax, status) ->
      response = $.parseJSON(ajax.responseText)
      html = response.html

      # エラーフォームへの置きかえ
      $('#history_form').html html