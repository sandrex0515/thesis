window.onload = function() {


var swiper2 = new Swiper('.v2', {
    
    centeredSlides: true,
    slidesPerView: 'auto',
    preventClicks: false,
    preventClicksPropagation: false,
    freemode: true,
    spaceBetween: 30,
pagination:{
  el: '.v2pp',
  clickable: true,
},
navigation:{
            nextEl: '.v2n',
            prevEl: '.v2p',  
},
autoplay:{
      delay:1500,
      disableOnInteraction:false,
},
});
}