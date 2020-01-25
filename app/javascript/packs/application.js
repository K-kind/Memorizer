// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require('@rails/ujs').start()
require('turbolinks').start()
require('@rails/activestorage').start()
require('channels')
require('jquery')
require('trix')
require('@rails/actiontext')
require('chartkick')
require('chart.js')
import $ from 'jquery';
import 'fullcalendar';

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

  $(document).on('click', '.login-form__closer', function () {
    $('.login-form, #calendar-modal, #always-modal').fadeOut('fast');
    setTimeout(() => {
      $('#overlay').remove();
    }, 100);
    return false;
  });

  $(document).on('click', '.later-modal-closer, #later-overlay', function () {
    $('#later-list-modal').html('');
    setTimeout(() => {
      $('#later-overlay').remove();
    }, 100);
    return false;
  });

  $(document).on('click', '.reset-modal-closer, #reset-overlay', function () {
    $('#password-reset-area').html('');
    setTimeout(() => {
      $('#reset-overlay').remove();
    }, 100);
    return false;
  });

  $(document).on('click', '#overlay', function () {
    $('.login-form, #calendar-modal, #always-modal').fadeOut('fast');
    $('#later-list-modal').html('');
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
    }
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
    document.getElementById('hidden_link').click();
    document.getElementById('hidden_link').remove();
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
    $(this).parent().next().slideDown();
    $(this).hide();
    return false;
  });
  $(document).on('click', '.remove-question-box', function () {
    $(this).parent().find('input[type="text"], textarea').val('');
    $(this).parent().slideUp();
    $(this).parent().prev().find('.add-next-box').show();
    return false;
  });

  // 問題のタイプごとの処理
  $('.question-type-select').change(function () {
    let $question = $('#learned_content_questions_attributes_0_question');
    let $answer = $('#learned_content_questions_attributes_0_answer');
    let word = $('#learned_content_main_word').find('option:selected').val();
    if ($(this).find('option:selected').val() == 0) {
      $question.val(``);
      $answer.val(``);
    } else if ($(this).find('option:selected').val() == 1) {
      if ($question.val() == '') {
        $question.val('[Image] What is the word related to these images?');
      } else {
        let original = $question.val();
        $question.val(`[Image] ${original}`);
      }
      if ($answer.val() == '') {
        $answer.val(`${word}`);
      }
    } else if ($(this).find('option:selected').val() == 2) {
      let definition1 = $(`[data-word="${word}"][data-type="definition"]`).eq(0).text();
      let definition2 = $(`[data-word="${word}"][data-type="definition"]`).eq(1).text();
      let definition3 = $(`[data-word="${word}"][data-type="definition"]`).eq(2).text();
      let definition = definition1 + '\n' + definition2 + '\n' + definition3
      $question.val(`${definition}`);
      $answer.val(`${word}`);
    }
  });

  if ($('#calendar').length) {
    function eventCalendar() {
      return $('#calendar').fullCalendar({});
    };
    function clearCalendar() {
      $('#calendar').html('');
    };
    
    $(document).on('turbolinks:load', function () {
      eventCalendar();
    });
    $(document).on('turbolinks:before-cache', clearCalendar);

    $('#calendar').fullCalendar({
      events: '/top.json',
      eventClick: function(event) { 
        CalendarPartial(event.start);
        return false;
      } ,
      //カレンダー上部を年月で表示させる
      titleFormat: 'YYYY年 M月',
      //曜日を日本語表示
      dayNamesShort: ['日', '月', '火', '水', '木', '金', '土'],
      //ボタンのレイアウト
      header: {
          left: '',
          center: 'title',
          right: 'today prev,next'
      },
      buttonText: {
          prev: '前',
          next: '次',
          prevYear: '前年',
          nextYear: '翌年',
          today: '今日',
          month: '月',
          week: '週',
          day: '日'
      },
      //イベントの時間表示を２４時間に
      timeFormat: "HH:mm",
      //イベントの色を変える
      eventColor: '#63ceef',
      //イベントの文字色を変える
      eventTextColor: '#000000',
    });
  }

  $(document).on('change', '.onclick-select', function () {
    Rails.fire($('#onclick-form')[0], 'submit');
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
  
  // サイクル設定フォーム
  $(document).on('change', '.my-page-container__cycle-form', function () {
    $('#add-cycle-btn').prop('disabled', true).addClass('disabled-btn');
  });

  $('#flash-box').fadeIn();
  setTimeout("$('#flash-box').fadeOut('slow')", 1800);
  $('#hidden-user-skill-link').fadeIn();

  // 1つ目の問題にフォーカス
  $('#learned_content_questions_attributes_0_my_answer').focus();
});

// カレンダーイベントクリックで、modal表示用リンクを生成してクリックする
function CalendarPartial(date) {
  $('#hidden-link').html(`<a id="hidden-link-to-date" href="homes/calendar?date=${date}" data-remote="true"></a>`);
  $('#hidden-link-to-date')[0].click();
  $('#hidden-link').html('');
};
