<?php
require_once('connection.php');
require_once('../../php/CLASSES/adminClass.php');
$data = array();
foreach($_POST as $k=>$v){
    $data[$k] = $v;
}
$class = new addPod ($data);
$datas = $class->login($data);
header("HTTP/1.1 404 Error");
if($datas['status']){
    $pk = 'pk'; 
	setcookie($pk, $datas['result'][0]['pk'], time()+7200000, '/');
    header("HTTP/1.1 200 Ok");
}



header("Content-Type:application/json");
print_r(json_encode($datas));
?>