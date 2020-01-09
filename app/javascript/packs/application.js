// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require('@rails/ujs').start()
require('turbolinks').start()
require('@rails/activestorage').start()
require('channels')
require('jquery')
require("trix")
require("@rails/actiontext")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

$(document).on('turbolinks:load', function () {
  $('.header-right__toggler--community').on('click', function () {
    $('.community-menu').fadeToggle('fast');
    return false;
  });

  $('.header-right__toggler--user').on('click', function () {
    $('.user-menu').fadeToggle('fast');
    return false;
  });
  
  $('#login-link').on('click', function () {
    $('#login-form').fadeIn('fast');
    $('body').append('<div id="overlay">');
    $('#email-form').focus();
    return false;
  });

  $('.signup-link').on('click', function () {
    $('#signup-form').fadeIn('fast');
    $('body').append('<div id="overlay">');
    $('#name-form').focus();
    return false;
  });

  $('.login-form__closer').on('click', function () {
    $('.login-form').fadeOut('fast');
    setTimeout(() => {
      $('#overlay').remove();
    }, 100);
    return false;
  });

  $(document).on('click', '#overlay', function () {
    $('.login-form').fadeOut('fast');
    setTimeout(() => {
      $(this).remove();
    }, 100);
  });

  $(document).on('click', '#login-toggler', function () {
    $('#signup-form').hide();
    $('#login-form').fadeIn('fast');
    $('#email-form').focus();
    return false;
  });

  $('#signup-toggler').on('click', function () {
    $('#login-form').hide();
    $('#signup-form').fadeIn('fast');
    $('#name-form').focus();
    return false;
  });

  $(document).on('click', '.audio-button', function () {
    $(this).parent().find('audio')[0].play();
  });

  $(document).on('click', '.more_lists', function () {
    $(this).parent().find('li').slideDown(180);
    $(this).parent().append('<a class="hide_lists">[-]</a>');
    $(this).remove();
    return false;
  });

  $(document).on('click', '.hide_lists', function () {
    $(this).parent().find('li:nth-of-type(n+4)').slideUp(180);
    $(this).parent().append('<a class="more_lists">[+]</a>');
    $(this).remove();
    return false;
  });

  $(document).on('click', '.dictionary-toggler', function () {
    $('.thesaurus-field').addClass('hidden');
    $('.dictionary-field').removeClass('hidden');
    return false;
  });

  $(document).on('click', '.thesaurus-toggler', function () {
    $('.dictionary-field').addClass('hidden');
    $('.thesaurus-field').removeClass('hidden');
    return false;
  });

  $(document).on('click', '.consulted-word', function () {
    let $clickedConsultedWord = $(this).text();
    $('.word-field').addClass('hidden');
    $('.word-field-' + $clickedConsultedWord).removeClass('hidden');
    return false;
  });

  $(document).on('click', '#consult-submit', function () {
    let $searchedWord = $('#word').val().replace(/[\s]/, '_');
    if ($('.word-field-' + $searchedWord).length) {
      $('.word-field').addClass('hidden');
      $('.word-field-' + $searchedWord).removeClass('hidden');
      return false;
    }
  });

  $(document).on('click', '.api-info__closer', function () {
    $('.api-info').html('');
  });

  $(document).off('click', '.image-save-btn');
  $(document).on('click', '.image-save-btn', function () {
    let $parent = $(this).parent();
    $(this).remove();
    let largeImageLink = $parent.find('.pixabay-image').attr('href');
    let thumbnailImageLink = $parent.find('.thumbnail-image').attr('src');
    let index = $parent.find('.pixabay-image').attr('data-index');
    let word = $parent.find('.pixabay-image').attr('data-word');
    $('#related_image').append(`<option data-index="${index}" value="${largeImageLink} ${thumbnailImageLink} ${word}" selected></option>`);
    let $saved = $('<span></span>');
    $saved.append('<span class="saved-image"></span>');
    $saved.find('.saved-image').append($parent.html());
    $saved.find('.saved-image').append("<a class='image-unsave-times fas fa-times'></a>");
    $('.learn-grid-container__saved-images').append($saved.html());
    $parent.append("<a class='image-unsave-star fa fa-star'></a>");
  });

  $(document).off('click', '.image-unsave-star');
  $(document).on('click', '.image-unsave-star', function () {
    let $parent = $(this).parent();
    $(this).remove();
    let index = $parent.find('.pixabay-image').attr('data-index');
    $(`.learn-grid-container__saved-images [data-index=${index}]`).parent().remove();
    $parent.append("<a class='image-save-btn far fa-star'></a>");
    $(`option[data-index=${index}]`).remove();
  });

  $(document).off('click', '.image-unsave-times');
  $(document).on('click', '.image-unsave-times', function () {
    let $parent = $(this).parent();
    let index = $parent.find('.pixabay-image').attr('data-index');
    $parent.remove();
    let $originalParent = $(`#images-result [data-index=${index}]`).parent();
    $originalParent.append("<a class='image-save-btn far fa-star'></a>");
    $originalParent.find('.image-unsave-star').remove();
    $(`option[data-index=${index}]`).remove();
  });

  if (document.getElementById('hidden_result_link')) {
    document.getElementById('hidden_result_link').click();
    document.getElementById('hidden_result_link').remove();
  }
});
