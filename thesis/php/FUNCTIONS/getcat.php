<?php
require_once('connection.php');
require_once('../../php/CLASSES/adminClass.php');

$class = new addPod (NULL);
$datas = $class->getcat();
header("HTTP/1.1 404 Error");
if($datas['status']){
    header("HTTP/1.1 200 Ok");
}



header("Content-Type:application/json");
print_r(json_encode($datas));
?>