// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require('@rails/ujs').start()
require('turbolinks').start()
require('@rails/activestorage').start()
require('channels')
require('jquery')


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
});