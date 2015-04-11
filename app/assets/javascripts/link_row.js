$(function(){
  $('.link-row').on('click', function(){
    window.location.href = $(this).data('href');;
  });
});