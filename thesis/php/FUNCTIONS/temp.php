<?php
require_once('connection.php');
require_once('../../php/CLASSES/adminClass.php');

$data = array();
foreach($_GET as $k=>$v){
    $data[$k]=$v;
}
$class = new addPod ($data);

$datas = $class->temp($data);
header("HTTP/1.1 404 Error");
if($datas['status']){
    header("HTTP/1.1 200 Ok");
    header('Location: http://localhost/sites/thesis/#/search');
}



header("Content-Type:application/json");
print_r(json_encode($data));
?>