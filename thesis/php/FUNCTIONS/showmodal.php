<?php

require_once('connection.php');
require_once('../../php/CLASSES/adminClass.php');

$class = new addPod (NULL,NULL,NULL);
$datas = $class->showmodal();
header("HTTP/1.1 404 Error");
if($datas['status']){
    header("HTTP/1.1 200 Ok");
}



header("Content-Type:application/json");
print_r(json_encode($datas));
?>

