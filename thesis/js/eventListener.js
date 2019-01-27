var closeMsg = document.getElementById("msgHead");
var ms = document.getElementById("msgMs");
var objDiv = document.getElementById("messengerBox");
var emo = document.getElementById("emoji");
var emoClose = document.getElementById("emojiContClose");
if(ms.addEventListener){
        ms.addEventListener("click", function() {
                document.getElementById("messengerBox").style.display ="block";
                objDiv.scrollTop = objDiv.scrollHeight;
        }, false);
       
       
}

if(closeMsg.addEventListener){
        closeMsg.addEventListener("click", function(){
                document.getElementById("messengerBox").style.display = "none";
        }, false);
}
if(emo.addEventListener){
        emo.addEventListener("click", function(){
                document.getElementById("emojiCont").style.display = "block";
                document.getElementById("emojiContClose").style.display = "block";
                objDiv.scrollTop = objDiv.scrollHeight;

        }, false);
}
if(emoClose.addEventListener){
        emoClose.addEventListener("click", function(){
                document.getElementById("emojiCont").style.display = "none";
                document.getElementById("emojiContClose").style.display = "none";

        }, false);
}