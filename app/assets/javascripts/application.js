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

$(function(){
  //サイドメニュー出現
  $(document).on('click', '.header__menu_humberger', function(){
    $('.body_wrap, .aside__menu').css('display', 'block');
  });
  //サイドメニュー消失
  // $('.aside__menu_wrap').on('click', '.body_wrap',function(){
  //   $('.aside__menu').css('display', 'none');
  //   $('.body_wrap').css('display', 'none');
  // });
  // $('.aside__menu').on('click', '.aside__menu_close',function(){
  //   $('.body_wrap').css('display', 'none');
  //   $('.aside__menu').css('display', 'none');
  // });

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

  // coming soon
  // $(document).on('click', '.coming_soon, .header__foot',function(){
  //   $('body').prepend($('<div>').addClass('displayed_coming_soon'));
  //   $('.displayed_coming_soon').append($('<div class="coming_soon_update">アップデートをお待ちください！</div>'));

  //   $(document).on('click', '.coming_soon_update',function(){
  //     $('.displayed_coming_soon').remove();
  //   });
  // });
});



