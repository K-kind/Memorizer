// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
import 'core-js/stable';
import 'regenerator-runtime/runtime';
require('@rails/ujs').start()
require('turbolinks').start()
require('@rails/activestorage').start()
require('channels')
require('jquery')
require('trix')
require('@rails/actiontext')
require('chartkick')
require('chart.js')
// import $ from 'jquery';
import 'fullcalendar';
import '@fullcalendar/daygrid/main.css';
import '@fullcalendar/core/main.css';

import '../stylesheets/application.scss';
import '../modules/fullcalendar';

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
const images = require.context('../images', true);
// const imagePath = (name) => images(name, true)
const headerTimeouts = [];

$(document).on('turbolinks:load', function () {
  // dsabled-btnがあればdisabledにしておく
  $('.disabled-btn').prop('disabled', true);
  $('.disabled-btn').click(function () {
    return false;
  })

  $(window).scroll(function () {
    $('.community-menu').fadeOut();
    $('.user-menu').fadeOut();
  });

  $('.header-right__toggler--community, .community-menu').hover(function () {
    clearTimeout(headerTimeouts[0]);
    $('.community-menu').fadeIn('fast');
    $('.user-menu').fadeOut('fast');
    headerTimeouts.shift();
  }, function() {
      headerTimeouts.push(
        setTimeout(() => $('.community-menu').fadeOut('fast'), 2400)
      );
  });

  $('.header-right__toggler--user, .user-menu').hover(function () {
    clearTimeout(headerTimeouts[0]);
    $('.user-menu').fadeIn('fast');
    $('.community-menu').fadeOut('fast');
    headerTimeouts.shift();
  }, function() {
    headerTimeouts.push(
      setTimeout(() => $('.user-menu').fadeOut('fast'), 2400)
    );
  });

  $('#login-link').on('click', function () {
    $('#login-form, #overlay').fadeIn('fast');
    $('#email-form').focus();
  });

  $('.signup-link').on('click', function () {
    $('#signup-form, #overlay').fadeIn('fast');
    $('#name-form').focus();
  });

  $(document).on('click', '.login-form__closer', function () {
    $('.login-form, #always-modal, #question-modal, #overlay').fadeOut('fast');
    $('#release-note-modal').html('');
  });

  $(document).on('click', '.later-modal-closer, #later-overlay', function () {
    // always-modalの上にかぶせる時だけlater-overlay
    // それ以外の時はoverlay
    $('#later-list-modal').html('');
    if ($('#later-overlay').is(':hidden')) {
      $('#overlay').fadeOut('fast');
    } else {
      $('#later-overlay').fadeOut('fast');
    }
  });

  $(document).on('click', '.reset-modal-closer, #reset-overlay', function () {
    $('#password-reset-area').html('');
    $('#reset-overlay').fadeOut('fast');
  });

  $('#overlay').click(function () {
    $('.login-form, #always-modal, #question-modal, #overlay').fadeOut('fast');
    $('#later-list-modal, #release-note-modal').html('');
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
    $(this).parent().append('<a class="hide_lists fas fa-chevron-circle-up"> hide examples</a>');
    $(this).remove();
    return false;
  });

  $(document).on('click', '.hide_lists', function () {
    $(this).parent().find('li:nth-of-type(n+4)').slideUp(180);
    $(this).parent().append('<a class="more_lists fas fa-chevron-circle-down"> more examples</a>');
    $(this).remove();
    return false;
  });

  $(document).on('click', '.dictionary-toggler', function () {
    let word = $(this).parent().attr('data-word'); // その単語だけの表示を変える
    let $parentField = $(`.word-field-${word}`);
    $parentField.find('.thesaurus-field').addClass('hidden');
    $parentField.find('.dictionary-field').removeClass('hidden');
    $(this).addClass('active-toggler');
    $(this).parent().find('.thesaurus-toggler').removeClass('active-toggler');
    return false;
  });

  $(document).on('click', '.thesaurus-toggler', function () {
    let word = $(this).parent().attr('data-word');
    let $parentField = $(`.word-field-${word}`);
    $parentField.find('.dictionary-field').addClass('hidden');
    $parentField.find('.thesaurus-field').removeClass('hidden');
    $(this).addClass('active-toggler');
    $(this).parent().find('.dictionary-toggler').removeClass('active-toggler');
    return false;
  });

  // 検索した単語をクリックすると、その単語の箱がdisplayされる
  $(document).on('click', '.consulted-word', function () {
    let clickedConsultedWord = $(this).text();
    $('.word-field').addClass('hidden');
    $('.word-field-' + clickedConsultedWord).removeClass('hidden');
    $('.consulted-word').removeClass('active-word');
    $(this).addClass('active-word');
    if ($('#pixabay-link').length) { // 画像検索リンク
      $('#pixabay-link').text(` "${clickedConsultedWord}"`);
      $('#pixabay-link').attr('href', `/pixabay?word=${clickedConsultedWord}`);
    }
    return false;
  });

  // ページ内で同じ単語を再検索した場合、appendせずにhiddenをremoveする
  $(document).on('click', '#consult-submit', function () {
    let searchedWord = $('#word').val().replace(/[\s]/, '_');
    $('#erasor').show();
    if ($('.word-field-' + searchedWord).length) {
      $('.word-field').addClass('hidden');
      $('.word-field-' + searchedWord).removeClass('hidden');
      $('.consulted-word').removeClass('active-word'); // 表示している単語ボタン
      $('.consulted-word-' + searchedWord).addClass('active-word');
      if ($('#pixabay-link').length) { // 画像検索リンク
        $('#pixabay-link').text(` "${searchedWord}"`);
        $('#pixabay-link').attr('href', `/pixabay?word=${searchedWord}`);
      }
      return false; // submitはしない
    } else {
      $('body').append('<p id=searching>問い合わせ中です...</p>');
      $('#searching').slideDown();
    }
  });

  $(document).on('click', '#erasor', function () {
    $('#word').val('');
    $('#word').focus();
    $(this).hide();
  });

  // 単語の意味タブの挙動
  $(document).on('click', '.dictionary-word-tab', function () {
    let clickedIndex = $(this).data('index');
    let word = $(this).data('word');
    $(`.dictionary_box_${word}`).each(function (index, element) {
      $(element).addClass('hidden');
      if (index === clickedIndex) {
        $(element).removeClass('hidden');
      }
    });
    // タブ自体の色を変更
    $(`.dictionary-word-tab[data-word="${word}"]`).removeClass('active-word-tab');
    $(this).addClass('active-word-tab');
  });
  $(document).on('click', '.thesaurus-word-tab', function () {
    let clickedIndex = $(this).data('index');
    let word = $(this).data('word');
    $(`.thesaurus_box_${word}`).each(function (index, element) {
      $(element).addClass('hidden');
      if (index === clickedIndex) {
        $(element).removeClass('hidden');
      }
    });
    // タブ自体の色を変更
    $(`.thesaurus-word-tab[data-word="${word}"]`).removeClass('active-word-tab');
    $(this).addClass('active-word-tab');
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

  if (document.getElementById('hidden_link')) {
    let $hidden_link = document.getElementById('hidden_link');
    $hidden_link.click();
    $hidden_link.remove();
  }
  if (document.getElementById('hidden_template_link')) {
    document.getElementById('hidden_template_link').click();
    document.getElementById('hidden_template_link').remove();
  }

  $(document).off('click', '.remove-word-btn');
  $(document).on('click', '.remove-word-btn', function () {
    let word = $(this).attr('data-word');
    $(`.main-word-select option[value="${word}"]`).remove();
    $(`#related_word option[value="${word}"]`).remove();
    $(`.word-field-${word}`).remove();
    $(this).parent().remove();
  });

  // 新規学習時の問題boxの動的な追加、削除
  $(document).on('click', '.add-next-box', function () {
    $(this).hide();
    $(this).parent().next().slideDown('fast');
  });
  $(document).on('click', '.remove-question-box', function () {
    $(this).parent().find('input[type="text"], textarea').val('');
    $(this).parent().slideUp();
    $(this).parent().prev().find('.add-next-box').show();
  });

  // 問題のタイプQuick
  $('#quick-question').click(function () {
    let $question = $('#learned_content_questions_attributes_0_question');
    let $answer = $('#learned_content_questions_attributes_0_answer');
    let word = $('#learned_content_main_word').find('option:selected').val();

    if ($(this).text() === 'Quick' && word !== undefined) {
      $(this).text('Delete')
      let definition1 = $(`[data-word="${word}"][data-type="definition"]`).eq(0).text();
      let definition2 = $(`[data-word="${word}"][data-type="definition"]`).eq(1).text();
      let definition3 = $(`[data-word="${word}"][data-type="definition"]`).eq(2).text();
      let definition = definition1 + '\n' + definition2 + '\n' + definition3
      $question.val(`[Definition]\n${definition}`);
      $answer.val(`${word}`);
    } else {
      $(this).text('Quick')
      $question.val('');
      $answer.val('');
    }
  });

  $(document).off('change', '.onclick-select');
  $(document).on('change', '.onclick-select', function () {
    Rails.fire($('#onclick-form')[0], 'submit');
  });

  $('.favo-onclick-select').change(function () {
    Rails.fire($('#favo-onclick-form')[0], 'submit');
  });

  // ユーザー編集
  $(document).on('click', '.my-page-container__edit-btn', function () {
    $('.my-page-container__original').hide();
    $('.my-page-container__form').show();
    $('.my-page-container__form').eq(0).find('input').focus();
    $(this).hide();
    $('.my-page-container__cancel-btn').show();
    $('.my-page-container__submit-btn').show();
  })

  // サイクル更新ボタンからdisabledを外す
  // サイクル設定更新と追加は一緒にできない
  $(document).on('change', '.my-page-container__cycle-form', function () {
    $('#cycle-edit').find('.disabled-btn')
                    .removeClass('disabled-btn')
                    .prop('disabled', false)
                    .off('click'); // return false を解除
    $('#add-cycle-btn').prop('disabled', true).addClass('disabled-btn');
  });

  // 学習設定のボタンからdisabledを外す
  $(document).on('input', '#learn_template_content', function() {
    $('#template-edit').find('.disabled-btn')
                        .removeClass('disabled-btn')
                        .prop('disabled', false)
                        .off('click');
  });

  // ページ遷移後にflashがある場合 flashTimeoutsはviewで定義
  if ($('#flash-box div').length) {
    let $flashBox = $('#flash-box');
    clearTimeout(flashTimeouts[0]);

    $flashBox.fadeIn();
    flashTimeouts.shift();
    flashTimeouts.push(setTimeout(() => $flashBox.fadeOut('slow'), 2400));
  }

  // flashをクリックして消す
  // $(document).on('click', '#flash-box', function () {
  $('#flash-box').click(function () {
    $(this).html('');
  });

  $(document).on('ajax:error', function() {
    alert('通信エラーが発生しました。ページを読み直してからもう一度お試しください。')
  });

  $('#hidden-user-skill-link').fadeIn();

  // 1つ目の問題にフォーカス
  if (window.matchMedia('(min-width: 768px)').matches) {
    $('#learned_content_questions_attributes_0_my_answer').focus();
  }

  $('#excellent').fadeIn();
  setTimeout(function () {
    $('#excellent').fadeOut();
  }, 1700);

  $('#loading-needed').click(function () {
    $('#loading').slideDown();
  })

  $('.help__drop-toggle').click(function () {
    $(this).parent().find('.help__drop-down').slideToggle('fast');
  });

  // hint
  $('.question-box__hint-link').click(function () {
    $(this).hide();
    $(this).parent().find('.question-box__hint').slideDown('fast');
  });

  // question words 切り替え
  $(document).off('click', '.q-w-toggler');
  $(document).on('click', '.q-w-toggler', function() {
    let $parent = $(this).parent();
    if ($(this).hasClass('to-word')) {
      $parent.find('.question-view').addClass('hidden');
      $parent.find('.word-view').removeClass('hidden');
      $(this).toggleClass('to-word')
             .text(' Question');
    } else {
      $parent.find('.question-view').removeClass('hidden');
      $parent.find('.word-view').addClass('hidden');
      $(this).toggleClass('to-word')
              .text(' Word');
    }
  });

  $('#header-menu').click(function() {
    $('#header-dropdown').slideToggle('fast');
    $(this).toggleClass('fa fa-times');
  });
});
