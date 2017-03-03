// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .


// $(function(){
  //サイドメニュー出現
  // $(document).on('click', '.header__menu_humberger', function(){
  //   $('.body_wrap, .aside__menu').css('display', 'block');
  // });

// nagashitest
$(function(){
  $('.header__menu_humberger').click(function(){
        $('.aside__menu').toggleClass('showMenue');
        $("#alert_background").fadeIn(500);
      });
  $('.aside__menu_list').click(function(){
      $('.aside__menu').toggleClass('showMenue');
      $("#alert_background").fadeOut(500);
      });
  });

$(function(){
  $("#alert_background").hide();

//   $(".nav__item").click(function(){
//     $("#alert_background").fadeIn(300);
//   });
//   $("#ok").click(function(){
//     $("#alert_background").fadeOut(300);
//   });
});
// testend

  // filereader();

  // $('.input_file').bind('change', function() {
  //   var size_in_megabytes = this.files[0].size/1024/1024;
  //   if (size_in_megabytes > 5) {
  //     alert("ファイルの最大サイズは5MBです。");
  //   }
  // });
// });

function filereader(){
  $(document).on('change', '#user_picture',function(){
    var file = $(this).prop('files')[0];
      var reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = function(e) {
        $('img.user_picture').attr("src", e.target.result);
      };
  });
  $(document).on('change', '#user_header_picture',function(){
    var file = $(this).prop('files')[0];
      var reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = function(e) {
        $('img.user_header_picture').attr("src", e.target.result);
      };
  });

  $(document).on('change', '#circle_picture',function(){
    var file = $(this).prop('files')[0];
      var reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = function(e) {
        $('img.circle_picture').attr("src", e.target.result);
      };
  });
  $(document).on('change', '#circle_header_picture',function(){
    var file = $(this).prop('files')[0];
      var reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = function(e) {
        $('img.circle_header_picture').attr("src", e.target.result);
      };
  });

  $(document).on('change', '#blog_picture_1',function(){
    var file = $(this).prop('files')[0];
      var reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = function(e) {
        $('img.blog_picture_1').attr("src", e.target.result);
      };
  });
  $(document).on('change', '#blog_picture_2',function(){
    var file = $(this).prop('files')[0];
      var reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = function(e) {
        $('img.blog_picture_2').attr("src", e.target.result);
      };
  });
  $(document).on('change', '#blog_picture_3',function(){
    var file = $(this).prop('files')[0];
      var reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = function(e) {
        $('img.blog_picture_3').attr("src", e.target.result);
      };
  });
  $(document).on('change', '#event_picture',function(){
    var file = $(this).prop('files')[0];
      var reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = function(e) {
        $('img.event_picture').attr("src", e.target.result);
      };
  });
}