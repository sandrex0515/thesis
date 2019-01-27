var loader;
function loginLoader(){
  loader = setTimeout(showPage, 2500);

}
function showPage() {
  document.getElementById("userLogin").style.display = "block";
  document.getElementById("loader").style.display = "none";
}