<?php
require_once('connection.php');
require_once('../../php/CLASSES/adminClass.php');
$datas = array();

foreach($_POST as $k => $v){
    $datas[$k] = $v;
}
$class = new addPod(
    $datas
);

$data1 = $class->analytics2($datas);

header("HTTP/1.1 404 Error");

    if($data1['status']){
        header("HTTP/1.1 200 Ok");
    }


header("Content-Type:application/json");
print_r(json_encode($data1));
?>