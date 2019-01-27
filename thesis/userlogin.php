<!doctype html>
<html lan="en-US" xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">
<meta http-equiv="x-ua-compatible" content="ie=edge">
<meta name="google-signin-client_id" content="659684437795-rfffpck4eac6cri9f4me2idmand3g18s.apps.googleusercontent.com">
<link rel="stylesheet" type="text/css" href="style/topsearch.css">
<link rel="stylesheet" type="text/css" href="style/style.css">
<link rel="stylesheet" type="text/css" href="style/stylerecommend.css">
<link rel="stylesheet" type="text/css" href="style/styletoday.css">
<link rel="stylesheet" type="text/css" href="style/swiper.min.css">
<link rel="stylesheet" type="text/css" href="style/swipercss.css">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/css/bootstrap.min.css" integrity="sha384-GJzZqFGwb1QTTN6wy59ffF1BuGJpLSa9DkKMp0DgiMDm4iYMj70gZWKYbI706tWS" crossorigin="anonymous">
<link href="https://fonts.googleapis.com/css?family=Bitter" rel="stylesheet">
<link href="https://fonts.googleapis.com/css?family=Indie+Flower" rel="stylesheet">
<link rel="stylesheet" href="style/font-awesome-4.7.0/css/font-awesome.min.css">
<title>E-commerce</title>


</head>
<body onload="loginLoader()" style="margin: 0;">
  <div id="loader">
  <div class="wrapper">
    <div class="circle circle-1"></div>
    <div class="circle circle-1a"></div>
    <div class="circle circle-2"></div>
    <div class="circle circle-3"></div>
  </div>
  <h1 class="loadLoad">Loading&hellip;</h1>
  </div>




<div class="userLogin" id="userLogin" style="display:none;">
<p class="loginHead">Login</p>    
<br>
<div id="my-signin2"></div> 
<p>-------------- OR --------------</p> 

<div id="fb-root"></div>
<div class="fb-login-button" data-width="240" data-max-rows="1" data-size="large" data-button-type="continue_with" data-show-faces="false" data-auto-logout-link="true" data-use-continue-as="false"></div>

<br>
</div>
<script src="js/loader.js"></script>
<script>
(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = 'https://connect.facebook.net/en_US/sdk.js#xfbml=1&version=v3.2&appId=1971573373150162&autoLogAppEvents=1';
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));
</script>

  <script>
    function onSuccess(googleUser) {
      console.log('Logged in as: ' + googleUser.getBasicProfile().getName());
    }
    function onFailure(error) {
      console.log(error);
    }
    function renderButton() {
      gapi.signin2.render('my-signin2', {
        'scope': 'profile email',
        'width': 240,
        'height': 50,
        'longtitle': true,
        'theme': 'dark',
        'onsuccess': onSuccess,
        'onfailure': onFailure
      });
    }
  </script>

  <script src="https://apis.google.com/js/platform.js?onload=renderButton" async defer></script>
</body>
</html>