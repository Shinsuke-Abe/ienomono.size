# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  get_html_from_ajax_response=(ajax) ->
    response = $.parseJSON(ajax.responseText)
    response.html

  update_history_form=(ajax) ->
    #フォーム領域を書き換え
    $('#history_form').html get_html_from_ajax_response ajax
    $('#latest_history').css('display', 'none')

  $('#new_history')
    .on 'ajax:complete', (event, ajax, status) ->
      update_history_form ajax
    .on 'ajax:error', (event) ->
      $('#history_form').append "エラー"

  $('#edit_history')
    .on 'ajax:complete', (event, ajax, status) ->
      update_history_form ajax
    .on 'ajax:error', (event) ->
      $('#history_form').append "エラー"

  $('#edit_taggings')
    .on 'ajax:complete', (event, ajax, status) ->
      $('#taggings').html get_html_from_ajax_response ajax
    .on 'ajax:error', (event) ->
      $('#taggings').append "エラー"

  $('#history_form')
    .on 'ajax:complete', (event, ajax, status) ->
      $('#history_form').html get_html_from_ajax_response ajax