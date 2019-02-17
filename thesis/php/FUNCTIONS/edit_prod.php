<?php
require_once('connection.php');
require_once('../../php/CLASSES/adminEdit.php');
$class = new addedit(
        $_POST['id'],
        $_POST['description'],
        $_POST['price'],
        $_POST['type'],
        $_POST['item_id'],
        $_POST['item'],
        $_POST['quantity']
      
);

$data = $class->editprod();
$data = $class->editstock();
header("HTTP/1.1 404 Error");
if($data['status']){
    header("HTTP/1.1 200 Ok");
    
}



header("Content-Type:application/json");
print_r(json_encode($data));
?>