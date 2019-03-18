<?php
require_once('connection.php');
require_once('../../php/CLASSES/adminClass.php');

$class = new addPod(
    NULL,NULL, NULL
);

$data1 = $class->analytics3();

header("HTTP/1.1 404 Error");

    if($data1['status']){
        header("HTTP/1.1 200 Ok");
    }


header("Content-Type:application/json");
print_r(json_encode($data1));
?>