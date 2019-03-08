<?php
require_once('connection.php');
require_once('../../php/CLASSES/adminClass.php');
require_once('../../PHPMailer/src/PHPMailer.php');
require_once('../../PHPMailer/src/Exception.php');
require_once('../../PHPMailer/src/SMTP.php');
require_once('../../PHPMailer/src/PHPMailerAutload.php');

$data = array();
foreach($_POST as $k=>$v){
    $data[$k]=$v;
}
$class = new addPod ($data);

$datas = $class->delivery($data);
header("HTTP/1.1 404 Error");
$email = $data['email'];
if($datas['status']){

//     $mail = new PHPMailer;
//   //$mail->SMTPDebug = 3;
//   $mail->isSMTP();                                      
//   $mail->Host = 'smtp.elasticemail.com';                       
//   $mail->SMTPAuth = true;                               
//   $mail->Username = 'sandrex.kami@gmail.com';          
//   $mail->Password = '09193660273';                         
//   $mail->SMTPSecure = 'tls';                            
//   $mail->Port = 2525;                                   

//   $mail->setFrom('SANDREX CABRALES', 'SAMPLE');
//   $mail->addAddress($email);
//   $mail->isHTML(true);
//   $mail->Subject = 'SAMPLE ORDER!';
//   $mail->Body    = 'SAMPLE';

//   if(!$mail->send()) {
//   echo "Mailer Error: " . $mail->ErrorInfo;
//   header("HTTP/1.0 500 Internal Server Error");
//   } else {
//   }

    header("HTTP/1.1 200 Ok");


}



header("Content-Type:application/json");
print_r(json_encode($datas));
?>