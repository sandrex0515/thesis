<?php
require_once('connection.php');
require_once('../../php/CLASSES/adminClass.php');
// require_once('../../php/CLASSES/mailer.php');

$data = array();
foreach($_POST as $k=>$v){
    $data[$k] = $v;
}

$class = new addPod ($data);
$datas = $class->delivered($data);

header("HTTP/1.1 404 Error");
if($datas['status']){
    header("HTTP/1.1 200 Ok");

//     $body = 'hello';
//     $mail = new PHPMailer;

//     //$mail->SMTPDebug = 3;                               // Enable verbose debug output
    
//     $mail->isSMTP();                                      
//     $mail->Host = 'smtp.elasticemail.com';                       
//     $mail->SMTPAuth = true;                               
//     $mail->Username = 'sandrex.kami@gmail.com';          
//     $mail->Password = '09193660273';                         
//     $mail->SMTPSecure = 'tls';                            
//     $mail->Port = 2525;                                   
    
//     $mail->setFrom('sandrex.kami@gmail.com', 'E-commerce');
//     foreach($datas as $k=>$v){
//     $mail->addAddress($v['email']);
// }     // Add a recipient
//     //$mail->addReplyTo('info@example.com', 'Information');
    
//     //$mail->addAttachment('/var/tmp/file.tar.gz');         // Add attachments
//     //$mail->addAttachment('/tmp/image.jpg', 'new.jpg');    // Optional name
//     $mail->isHTML(true);                                  // Set email format to HTML
    
//     $mail->Subject = 'sample';
//     $mail->Body    = '<br /><br />';
//     $mail->Body    = '<b>Security Code</b>';
//     $mail->Body    = '<br /><br />';
//     $mail->Body    = $body;
    
//     if(!$mail->send()) {
//     echo "Mailer Error: " . $mail->ErrorInfo;
//     header("HTTP/1.0 500 Internal Server Error");
//     } else {
//         header("HTTP/1.0 200 OK");
//     }
}



header("Content-Type:application/json");
print_r(json_encode($datas));
?>