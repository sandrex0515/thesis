<?php
require_once('connection.php');
require_once('../../php/CLASSES/adminClass.php');
$class = new addPod (
               null,
               null,
               null,
               null

);

$data = $class->fetch();

header("HTTP/1.1 404 Error");


$delimited = ",";
$filename = "Order_" . date('Y-m-d') . ".csv";

$f = fopen('php://memory', 'w');

$fields = array('Item', 'Price', 'Customer', 'Address', 'Contact', 'Signature');
fputcsv($f, $fields, $delimeted);

// foreach($class as $k=>$v){
//     $type = $v['type'];
//     $lineData = array($type);
//     fputcsv($f, $lineData, $delimeted);
// }
fseek($f, 0);
header('Content-Type: text/csv');
header('Content-Disposition: attachment; filename="' . $filename . '"; ');
fpassthru($f);

if($data['status']){
    header("HTTP/1.1 200 Ok");
}



header("Content-Type:application/json");
exit;
?>