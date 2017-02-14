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
  $(document).on('click', '.header__menu_humberger', function(){
    $('.body_wrap, .aside__menu').css('display', 'block');

    // スクロール禁止
    // $(window).on('touchmove.noScroll', function(e) {
    //   e.preventDefault();
    // });

  });
  $(document).on('click', '.body_wrap, .aside__menu_close',function(){
    $('.body_wrap, .aside__menu').css('display', 'none');
  });
});