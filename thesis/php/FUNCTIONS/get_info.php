<?php
require_once('connection.php');
require_once('../../php/CLASSES/adminClass.php');
$data = array();

foreach($_POST as $k=>$v){
    $data[$k] = $v;
}
$pk = $data['pk'];
$class = new addPod ($pk);

$datas = $class->get_info($pk);

header("HTTP/1.1 404 Error");
if($datas['status']){
    header("HTTP/1.1 200 Ok");
}



header("Content-Type:application/json");
print_r(json_encode($datas));
?>