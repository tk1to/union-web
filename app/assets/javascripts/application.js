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
  $(document).on('click', '.body_wrap, .aside__menu_close',function(){
    $('.body_wrap, .aside__menu').css('display', 'none');
  });

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
});