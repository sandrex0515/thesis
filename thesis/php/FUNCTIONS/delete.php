<?php
require_once('connection.php');
require_once('../../php/CLASSES/adminDelete.php');
$class = new addPod(

               $_POST['item_id']
               

);

$data = $class->delprod();
header("HTTP/1.1 404 Error");
if($data['status']){
    header("HTTP/1.1 200 Ok");
    
}


header("Content-Type:application/json");
print_r(json_encode($data));
?>