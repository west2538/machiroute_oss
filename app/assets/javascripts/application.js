// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require serviceworker-companion
//= require rails-ujs
//= require activestorage
//= require jquery.min
//= require jquery_ujs
//= require jquery-ui/widgets/autocomplete
//= require turbolinks
//= require nested_form_fields
//= require gmaps/google
//= require toastr_rails
//= require moment
//= require moment/ja.js
//= require_tree .

// Turbolinks 画面遷移時のプログレスバー

$(function() {
    Turbolinks.setProgressBarDelay(100);
});

function updateCount(str, id)
  {
    var obj = document.getElementById(id);
    if(str)
    {
        obj.innerHTML = str.length;
    }
    else
    {
        obj.innerHTML = '0';
    }
  }

// 投稿画面 ctrl + enter対応

$(document).on("turbolinks:load", function() {
    $('#commentInput').keydown(function(e){
        if(event.ctrlKey){
        if(e.keyCode === 13 && $(this).val()){
            $('#commentSubmit').submit();
            return false;
        }
        }
    });
});

// 投稿画面のセレクトボックス

$(document).on("turbolinks:load", function() {
  $('select').change(function() {
    if ($(this).val() == '新規サブクエスト'){
    var holder = '世の中ちょっと明るくなるやつ頼みます！'
    }
    if ($(this).val() == '冒険中のつぶやき'){
    var holder = '人生はRPG！冒険中にあった出来事をどうぞ！'
    }
    if ($(this).val() == '駅でチェックイン'){
    var holder = 'その駅ではどんな出来事がありましたか？'
    }
    if ($(this).val() == '冒険の拠点を登録'){
    var holder = 'どんな拠点ですか？そこでの出会いから共感と展開が生まれますように'
    }
    if ($(this).val() == 'ただのつぶやき'){
    var holder = 'どうでもいいこともOK！ぼやきも必要ですよ'
    }
    if ($(this).val() == '書籍や漫画を読んだ'){
    var holder = '感想は？もしかして魔導書!?どんなスキルUPになりました？'
    }
    if ($(this).val() == 'ニュース'){
    var holder = '冒険者として気になるニュースを投稿してシェアしよう'
    }
    if ($(this).val() == '公式のつぶやき'){
    var holder = '開発おつかれさまです'
    }
    if ($(this).val() == '復活の呪文でHP回復'){
    var holder = 'あなたの呪文をどうぞ！'
    }
    $('h4').text(holder);
  });
});

// 書籍検索

$(document).on("turbolinks:load", function() {
    $(function() {
        $('#getBookInfo').click( function( e ) {
            e.preventDefault();
            const booktitle = $("#booktitle").val();
            const bookisbn = booktitle;
            const url = "https://api.openbd.jp/v1/get?isbn=" + booktitle;

            $.getJSON( url, function( data ) {
                if( data[0] == null ) {
                    alert("書籍が見つかりません");
                } else {
                    if( data[0].summary.cover == "" ){
                        $("#thumbnail").html('<input type=\"hidden\" name=\"post[bookisbn]\" value=\"' + bookisbn + '\"><input type=\"hidden\" name=\"post[bookpublisher]\" value=\"' + data[0].summary.publisher + '\"><input type=\"hidden\" name=\"post[bookauthor]\" value=\"' + data[0].summary.author + '\"><input type=\"hidden\" name=\"post[bookpubdate]\" value=\"' + data[0].summary.pubdate + '\"><input type=\"hidden\" name=\"post[bookcover]\" value=\"' + data[0].summary.cover + '\">');
                    } else {
                        $("#thumbnail").html('<div><img src=\"' + data[0].summary.cover + '\" style=\"border:solid 1px #000000\" /></div><input type=\"hidden\" name=\"post[bookisbn]\" value=\"' + bookisbn + '\"><input type=\"hidden\" name=\"post[bookpublisher]\" value=\"' + data[0].summary.publisher + '\"><input type=\"hidden\" name=\"post[bookauthor]\" value=\"' + data[0].summary.author + '\"><input type=\"hidden\" name=\"post[bookpubdate]\" value=\"' + data[0].summary.pubdate + '\"><input type=\"hidden\" name=\"post[bookcover]\" value=\"' + data[0].summary.cover + '\">');
                    }
                    $("#booktitle").val(data[0].summary.title);
                }
            });
        });
    });

// 駅でチェックイン

$('#getStationInfo').click( function( e ) {
var output = document.getElementById("result");
if (!navigator.geolocation){
    output.innerHTML = "<p>Geolocationはあなたのブラウザーでサポートされておりません</p>";
    return;
}
function success(position) {
    var latitude  = position.coords.latitude;
    var longitude = position.coords.longitude;

    const url = "https://express.heartrails.com/api/json?method=getStations&x=" + longitude + "&y=" + latitude + "&jsonp=?";

    $.getJSON(url, function( jsonp ) {

        if( jsonp.response.station[0] == null ) {
            alert("最寄り駅が見つかりません");
        } else {

            for(var i in jsonp.response.station) {
              if (i == 0) {
                $("#searchstation").replaceWith("<option value=" + jsonp.response.station[i].name + '駅（' + jsonp.response.station[i].line + '）' + ">" + jsonp.response.station[i].name + '駅（' + jsonp.response.station[i].line + '）' + "</option>");
              } else {
                $("#stationname").append("<option value=" + jsonp.response.station[i].name + '駅（' + jsonp.response.station[i].line + '）' + ">" + jsonp.response.station[i].name + '駅（' + jsonp.response.station[i].line + '）' + "</option>");
              }
            }
            }
        });
    };

function error() {
    output.innerHTML = "座標位置を取得できません";
};
navigator.geolocation.getCurrentPosition(success, error);

});
});

// disable-with iOS対応

// $(document).on("turbolinks:load", function() {
//   if (!navigator.vendor.indexOf("Apple")==0 && /\sSafari\//.test(navigator.userAgent)) {
//     return;
//   }

//   var formHandler = function (e) {
//     var rails = $.rails;
//     var form = $(this),
//       remote = form.data('remote') !== undefined,
//       blankRequiredInputs,
//       nonBlankFileInputs;

//     if (!rails.allowAction(form)) return rails.stopEverything(e);

//     if (form.attr('novalidate') == undefined) {
//       blankRequiredInputs = rails.blankInputs(form, rails.requiredInputSelector);
//       if (blankRequiredInputs && rails.fire(form, 'ajax:aborted:required', [blankRequiredInputs])) {
//         return rails.stopEverything(e);
//       }
//     }

//     if (remote) {
//       nonBlankFileInputs = rails.nonBlankInputs(form, rails.fileInputSelector);
//       if (nonBlankFileInputs) {
//         setTimeout(function(){ rails.disableFormElements(form); }, 13);
//         var aborted = rails.fire(form, 'ajax:aborted:file', [nonBlankFileInputs]);

//         if (!aborted) { setTimeout(function(){ rails.enableFormElements(form); }, 13); }

//         return aborted;
//       }

//       rails.handleRemote(form);
//       return false;

//     } else {
//       if (!e.isTrigger) {
//         e.preventDefault();
//         rails.disableFormElements(form);
//         setTimeout(function(){ form.trigger('submit'); }, 13);
//       }
//     }
//   };

//   $(document).undelegate('form', 'submit.rails');
//   $(document).delegate('form', 'submit.rails', formHandler);
// });

// 冒険中のつぶやき モーダルウィンドウ

$(document).on("turbolinks:load", function () {

$('#modalCenter').on('shown.bs.modal', function (e) {
  document.getElementById('modalinput').focus();
})

});

// $(document).on("turbolinks:load", function() {
 
//     $("#modal-open").click(function(){
//      $("body").append('<div id="modal-bg"></div>');
 
//     modalResize();
 
//     $("#modal-bg,#modal-main").fadeIn("fast");

//     document.getElementById('modalinput').focus();
 
//     $(window).keyup(function(e){

// 	if(e.keyCode == 27){
//             $("#modal-main,#modal-bg").fadeOut("fast",function(){
//             $('#modal-bg').remove() ;
//          });
//     }
//     });

//     $("#modal-bg").click(function(){
//           $("#modal-main,#modal-bg").fadeOut("fast",function(){
//               $('#modal-bg').remove() ;
//          });
 
//     });
    
//     $(window).resize(modalResize);
//     function modalResize(){

//         var w = $(window).width();
//         var h = $(window).height();

//         var cw = $("#modal-main").outerWidth();
//         var ch = $("#modal-main").outerHeight();

//         $("#modal-main").css({
//             "left": ((w - cw)/2) + "px",
//             "top": ((h - ch)/2-80) + "px"
//         });
//      }
//    });
// });

// Web Share API

$(document).on("turbolinks:load", function () {
  'use strict';

  if (typeof navigator.share === 'undefined') {
      return;
  }

  var btnShare = document.querySelectorAll('.js-btn-share');
  var shareData = {
      title: document.querySelector('title').textContent,
      text: document.querySelector('meta[property="og:title"]').getAttribute('content'),
      url: location.href
  };

  btnShare.forEach(function (selfBtn) {
      selfBtn.style.display = 'inline';

      selfBtn.addEventListener('click', function () {
          navigator.share(shareData)
              .then(function () {
                  // シェア完了後の処理
              })
              .catch(function (error) {
                  // シェア失敗時の処理
              });
      });
  });
});

// Mastodon WebSocketに接続してリアルタイム通知

$(document).on("turbolinks:load", function () {

var current_uid = document.getElementsByName('current_user')[0].content;
var current_token = document.getElementsByName('current_token')[0].content;
var session_bunkatsu = current_uid.split('@');
var sock = new WebSocket('wss://' + session_bunkatsu[1] + '/api/v1/streaming?stream=user&access_token=' + current_token);
sock.addEventListener('open',function(e){
    console.log('Mastodon WebSocket 接続成功');
});

const messagerecieve = (e) => {
  var obj1 = JSON.parse(e.data);
  var obj2 = JSON.parse(obj1.payload);
  var obj3 = obj2.account;
  var obj4 = obj3.url;
  var obj5 = obj4.replace('https://', '')
  var session_bunkatsu2 = obj5.split('/@');
  // console.log(session_bunkatsu2[1] + "@" + session_bunkatsu2[0]);
  if (obj1.event === 'notification' || obj1.event === 'mention'){
      var target = document.getElementById("dropdownMenu1");
      target.className = "btn btn-sm btn-default btn-success dropdown-toggle";
      var element = document.getElementById("mstdn_notification");
          element.insertAdjacentHTML("afterbegin", "<a href='https://" + session_bunkatsu[1] + "' target='_blank' class='list-group-item pb-0' style='width:210px;'><div class='small clearfix'><p class='mb-0'><br><span class='font-weight-bold'>Mastodonに<br>通知が届いています</span></p><p class='mt-0' style='float:right;'><span data-livestamp='" + obj2.created_at + "'></span></p></div></a>");

      // var uri = "http://192.168.14.2:3000/api/v1/notifications" // 開発環境
      var uri = "https://machiroute.herokuapp.com/api/v1/notifications" // 本番環境
      var data = "since_id=" + obj2.id + "&send_to_uid=" + current_uid + "&send_from_uid=" + session_bunkatsu2[1] + "@" + session_bunkatsu2[0] + "&notified_type=mastodon&token=" + current_token
      var request = new XMLHttpRequest();
      request.open('POST', uri);
      request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
      request.send(data);
  };
  sock.removeEventListener('message', messagerecieve);
}

sock.addEventListener('message', messagerecieve);

});

// gem toastr_railsのオプション

toastr.options = {
  "closeButton": true,
  "debug": false,
  "newestOnTop": false,
  "progressBar": true,
  "positionClass": "toast-top-right",
  "preventDuplicates": false,
  "onclick": null,
  "showDuration": "300",
  "hideDuration": "1000",
  "timeOut": "5000",
  "extendedTimeOut": "1000",
  "showEasing": "swing",
  "hideEasing": "linear",
  "showMethod": "show",
  "hideMethod": "hide"
}

// バッテリーホイミ機能

navigator.getBattery().then(function(battery) {
   
  battery.onchargingchange = function(){
    if (battery.charging === true) {
      if(document.getElementById("posts") != null){
        var element = document.getElementById("posts");
        element.insertAdjacentHTML("afterend", "<tr><td class='px-0'><div class='box26'><span class='box-title'><i class='fa fa-battery-three-quarters' aria-hidden='true'></i> 充電を検知</span><p>充電の残量が変化すると数字が現れてその分だけHPが回復可能となります</p><section id='sec01'><form class='mt-3' action='battery' accept-charset='UTF-8' method='get'><input name='utf8' type='hidden' value='✓'><div class='input-group'><input type='text' class='form-control' style='width:100px;' id='battery' name='battery' readonly=''></input><button name='button' id='battery_btn' type='submit' class='btn btn-blue700_rsd ml-1' data-disable-with='パラリラ～ <i class=&#39;fa fa-spinner fa-spin&#39;></i>' disabled>ホイミ！</button></div></form></section></div></td></tr>");
      }
    }
  }
 
  battery.onlevelchange = function(){
    if(document.getElementById("battery") != null){
      document.getElementById( "battery" ).value = battery.level * 100;
      document.getElementById( "battery_btn" ).disabled = "";
    }
  }
 });