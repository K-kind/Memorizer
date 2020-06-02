// カレンダーイベントクリックで、modal表示
function CalendarPartial(calendarId) {
  $.ajax({
    type: 'GET',
    url: `date/${calendarId}.js`,
    dataType: 'html'
  }).done(function(data) {
    $('#calendar-show').html(data);
  }).fail(function() {
    alert('通信に失敗しました。ページを読み直してからもう一度お試しください。');
  });
};

$(document).on('turbolinks:load', function () {
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
      events: '/calendar.json',
      eventClick: function(event) {
        CalendarPartial(event.calendar_id);
      } ,
      //カレンダー上部を年月で表示させる
      // titleFormat: 'YYYY年 M月',
      //曜日を日本語表示
      // dayNamesShort: ['日', '月', '火', '水', '木', '金', '土'],
      //ボタンのレイアウト
      header: {
          left: '',
          center: 'title',
          right: 'today prev,next'
      },
      buttonText: {
          prev: 'prev',
          next: 'next',
          // prevYear: '前年',
          // nextYear: '翌年',
          // today: '今日',
          // month: '月',
          // week: '週',
          // day: '日'
      },
      //イベントの時間表示を２４時間に
      timeFormat: "HH:mm",
      //イベントの色を変える
      eventColor: '#63ceef',
      //イベントの文字色を変える
      eventTextColor: '#000000',
      // 月曜から
      // firstDay : 1
    });
  }
});
