<?php

$_id = 'pk';

if(isset($_COOKIE[$_id]) && !empty($_COOKIE[$_id])){
    setcookie($_id, $_COOKIE[$_id], time()-7200000, '/');
    unset($_COOKIE[$_id]);
	header("HTTP/1.0 200 OK");

	header('Content-Type: application/json');
	// print(
	// 		json_encode(
	// 					array(
	// 							$_id=>$_COOKIE[$_id]
	// 						)
	// 				)
	// 	);

}
else{
	header("HTTP/1.0 404 No active session");
}
// $data = array();
// foreach($data as $k=>$v){
//     $data[$k] = $v;
// }

?>