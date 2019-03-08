<?php
require_once('connection.php');
require_once('../../php/CLASSES/adminClass.php');

$data = array();
foreach($_GET as $k=>$v){
	$data[$k]= $v;
}
$class = new addPod(
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL
);
$datas = $class->csv2();
$titlehead = ', , , Delivered Order , , ,';
$sal = '=sum(d6:d92732)';
$sa = 'Total Sales';
$header = '#, Item, Quantity , Total, Customer, Address, Contact, Date , ';
$subheader = ' , , , , , ';
$count = 1;
$body = '';
$total = '';
foreach($datas['result'] as $k => $v) {
	
        $salary = $v['price'];
        $quan = $v['quantity'];
        $total = $salary * $quan;

	    $empdate = date("M j, Y", strtotime($v['delivered_date']));
        $empdate1 = strtotime($empdate);
	$body .= $count.','
	        .$v['item'].','
	        .$quan.','
			.$cirr.round($total,2). ','
            .$v['name'].','
			.$v['address'].','
            .$v['contact'].','
            .$empdate.','."\n";
			
            $count++;
            
            $sales = $salary++; 
}
	// $body1 .= $count1.',' 
	// 		.$count3.','
	// 		.$count1.','
	// 		.$data['emp'].','
	// 		.$data['empno'].','
	// 		.$data['empadd'].','
	// 		.$data['empadd']."\n";




$filename = "Order".date('Ymd_His').".csv";
header ("Content-type: application/octet-stream");
header ("Content-Disposition: attachment; filename=".$filename);
echo $titlehead."\n \n".", , , , , , , , ,".$sa.",".$sal."\n".$header."\n".$subheader."\n".$body;

?>