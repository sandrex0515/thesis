<?php
require_once('connection.php');
require_once('../../php/CLASSES/adminClass.php');
$class = new addPod (
                $_POST['name'],
                $_POST['descript'],
                $_POST['price'],
                $_POST['stock'],
                $_POST['category']
);

$data = $class->addProd();
$data = $class->addStock();
header("HTTP/1.1 404 Error");
if($data['status']){
    header("HTTP/1.1 200 Ok");
}

header("Content-Type:application/json");
print_r(json_encode($data));
?>