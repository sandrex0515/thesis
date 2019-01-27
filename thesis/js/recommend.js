var swiper = new Swiper('.v1', {
    effect: 'coverflow',
    grabCursor: true,
    centeredSlides: true,
    slidesPerView: 4,
    preventClicks: false,
    preventClicksPropagation: false,
   
    coverflowEffect: {
      rotate: 50,
      stretch: 0,
      depth: 100,
      modifier: 1,
      slideShadows : true,
    },
    
    scrollbar:{
      el: '.v1pp',
      hidden: true,
    },
    navigation:{
      nextEl: '.v1n',
      prevEl: '.v1p',    
                },
    autoplay:{
      delay:2500,
      disableOnInteraction:false,
    },
  });