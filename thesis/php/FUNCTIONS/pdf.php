<?php
require_once('connection.php');
require_once('../../php/CLASSES/adminClass.php');
require_once('../../php/CLASSES/fpdf.php');


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
$data = $class->pdf();


class PDF extends FPDF
{

	function construct ($margin = 6)
	{
	$this->SetTopMargin($margin);
	$this->SetLeftMargin($margin);
	$this->SetRightMargin($margin);
	$this->SetAutoPageBreak(true, $margin);
	}

	// function Header()
	// {
	// 	$this->Ln(3);
	//     $this->SetFont('Arial', 'B', 16);
	// 	$this->SetFillColor(36, 96, 84);
	// 	$this->Cell(0, 1, "TIMESHEET", 0, 0, 'C');
	// 	// $this->SetXY(20,-23);
	//     $this->Ln(10);
	// }

	// function Footer() {
	// 	$this->SetFont('Arial', '', 10);
	// 	$this->SetTextColor(0);
	// 	$this->SetXY(20,-23);
	// 	$this->Cell(0, 20, "CONFIDENTIAL", 'T', 0, 'L');
	// }

	function SetCellMargin($margin){
        // Set cell margin
        $this->cMargin = $margin;
    }
}

	$pdf = new PDF();
	$pdf->SetFont('Arial','',10);
	$pdf->setCellMargin(1);
	$pdf->construct();
	$pdf->AddPage('C',array(368, 279.4));
	$pdf->Ln();
    // $pdf->Cell(190,6,'PLEASE READ INSTRUCTION AT THE BACK BEFORE ACCOMPLISHING THIS FORM',0,'L',0);
    // // $pdf->Cell(22,6,'','',0,'L',0);
	// // $pdf->Cell(40,12,'PANDAS','',0,'L',0);
	// // $pdf->Ln();
	// // $pdf->SetFont('Arial','',10);
	// // $pdf->Cell(25,6,'','',0,'L',0);
    // // $pdf->Cell(30,6,'SAMPLE','',0,'L',0);
	// // $pdf->Cell(70,5,'Report of Employee Member','',0,'L',0);

	// // $pdf->Cell(10,5,$data['image'],'',0,'L',0);
	// // $pdf->Cell(100,6,$pdf->Image('../../ASSETS/img/panda.png',10,5	, $pdf->GetY(), 20.40));
	$pdf->Ln();
    $pdf->SetFont('Arial','',20);
    $pdf->Cell(25,6,'','',0,'L',0);
    $pdf->Cell(40,12,'PANDAS','',0,'L',0);
    $pdf->Cell(565,12,'Er2','',0,'C',0);

    $pdf->Ln();

	$pdf->SetFont('Arial','',10);
	$pdf->Cell(25,6,'','',0,'L',0);
	$pdf->Cell(70,5,'REPORT OF EMPLOYEE MEMBERS','',0,'L',0);

	$pdf->Cell(10,5,$data['image'],'',0,'L',0);
	$pdf->Cell(100,6,$pdf->Image('../../ASSETS/img/panda.png',10,5	, $pdf->GetY(), 20.40));

    $pdf->Ln();
    $pdf->Cell(355,6,'___________________________________________________________________________________________________________________________________________________________________________________','',0,'C',0);
    $pdf->Ln();
    

    $pdf->Ln();
   

   
    $pdf->SetFont('', '', 14);
	$pdf->Cell(60,16,'Name of Employer/Firm:','LTB',0,'C',0); 

	$pdf->Cell(136,16,$postdata['emp'],'TBR',0,'C',0);

	$pdf->Cell(50,16,'Employee No:','LTB',0,'C',0); 

	$pdf->Cell(110,16,$postdata['empno'],'TBR',0,'C',0);

	$pdf->Ln();
	$pdf->Cell(40,16,'Email Address:','LB',0,'C',0);
	// foreach($data['result'] as $k=>$v){
	// 	$pdf->Cell(88,16,$v['empadd'],'',0,'C',0);
	// 	}
	$pdf->Cell(115,16,$postdata['empadd'],'BR','C',0);

	$pdf->Cell(40,16,'Address:','B',0,'C',0);  

	$pdf->MultiCell(161,16,$postdata['empadd'],'BR','C',0);

	
	$pdf->SetFont('','',10);
	// foreach($data['result'] as $k=>$v){
	// // $pdf->Cell(50,6,'Name of Employer:','',0,'C',0); 

	// }

    $pdf->SetFont('Arial', 'B', 10.3);
	$pdf->Cell(35,8,'Philhealth Number','LRTB',0,'C',0);  
	$pdf->Cell(35,8,'SSS/GSIS Number','LRTB',0,'C',0);  
	$pdf->Cell(60,8,'Name of Employee ','LRTB',0,'C',0);  
	$pdf->Cell(38,8,'Date of Employment','LRTB',0,'C',0);  
    $pdf->Cell(40,8,'EFF. Date of Coverage','LRTB',0,'C',0);  
	$pdf->Cell(48,8,'Previous Employer','LRTB',0,'C',0);
	$pdf->Cell(30,8,'Salary','LRTB',0,'C',0);  
	$pdf->MultiCell(70,8,'Position','LRTB','C',0); 

	


	foreach($data['result'] as $k=>$v){
	if($v['sss'] == NULL){
	$v['sss'] === 'No data';
	}if($v['sss'] == 'null'){
	$v['sss'] === 'No data';
	}if($v['sss'] == ''){
	$v['sss'] === 'No data';
	}if($v['sss'] == false){
	$v['sss'] === 'No data';
	}
	$salary1 = '';
	$salary = number_format($v['salary']);
	if($salary == NULL){
	$salary1 = 'No data';
	}else{
	$salary1 = 'PHP ' . $salary ;
	}
	
	
	$pdf->SetFont('Arial', '', 10);
	$pdf->Cell(35,14,$v['phid'],'LRT',0,'C',0);
	$pdf->Cell(35,14,$v['sss'],'LRT',0,'C',0);
	 $pdf->Cell(60,14,$v['name'],'LRT',0,'C',0);
	 $empdate = date("M j, Y", strtotime($v['empdate']));
	 $pdf->Cell(38,14,$empdate,'LRT',0,'C',0);
	 $pdf->Cell(40,14,$v['effdatea'],'LRT',0,'C',0);
	 $pdf->Cell(48,14,$v[''],'LRT',0,'C',0);
	 $pdf->Cell(30,14, $salary1 ,'LRT',0,'C',0);
	 $pdf->MultiCell(70,5,$v['title'],'LRT','C',0);


$pdf->Ln();

	// $count += 1;
	// $v['personal'] = json_decode($v['personal'],true);
	// $v['hr_details'] = json_decode($v['hr_details'],true);
	// $v['supervisor_details'] = json_decode($v['supervisor_details'],true);
	
	// $pdf->Cell(10,6,$count,'LRB',0,'C',0);
	// $pdf->Cell(20,6,$v['employee_id'],'LRB',0,'C',0);
	// $pdf->Cell(30,6,$v['personal']['first_name'],'LRB',0,'C',0);
	// $pdf->Cell(20,6,$v['personal']['middle_name'],'LRB',0,'C',0);
	// $pdf->Cell(20,6,$v['personal']['last_name'],'LRB',0,'C',0);
	// $pdf->Cell(20,6,$v['hr_details']['last_day'],'LRB',0,'C',0);
	// $pdf->Cell(30,6,$v['hr_details']['effective_date'],'LRB',0,'C',0);
	// $pdf->Cell(30,6,$v['supervisor_details']['elig'],'LRB',0,'C',0);
	// $pdf->Cell(60,6,$v['hr_details']['reason'],'LRB',0,'C',0);
	// $pdf->Cell(100,6,$v['supervisor_details']['remark'],'LRB',0,'C',0);



	// $pdf->Ln();
	// $total  += $tot;
	// }
	
	}
	// 	$count += 1;
	// 	$pdf->Cell(30,6,$count,'',0,'C',0);
	// 	$pdf->Cell(120,6,$v['type'],'',0,'C',0);
	// 	$pdf->Cell(50,6,$v['amount'],'',0,'C',0);
	// 	$pdf->Ln();
	// // }
	// }
	// print_r($employees);
	// foreach ($employees as $k => $v) {
	// 	foreach ($v as $key => $value) {
	// 	$count += 1;
	// 	$timein = "";
	// 	$timeout = "";

	// 	if($value['time_in']['short']){
	// 	$timein = date('H:i:s', strtotime($value['time_in']['short']));
	// 	}
	// 	else {
	// 	$timein = "";
	// 	}

	// 	if($value['time_out']['short']){
	// 	$timeout = date('H:i:s', strtotime($value['time_out']['short']));
	// 	}
	// 	else {
	// 	$timeout = "";
	// 	}

	// 	$totalhrsum += $value['hrs'];
	// 	$totaltardysum += $value['tardiness'];
	// 	$totalundertimesum += $value['undertime'];
	// 	$totalovertimesum += $value['overtime'];
	// 	$namesvisor =  $value['supervisor_name'];

	// 	$timelongs = ucwords($value['day_long']);
	// 	$pdf->SetFont('', '', 10);
	// 	$pdf->Cell(25,6,$value['employee_id'],'',0,'C',0);
	// 	$pdf->Cell(70,6,$value['last_name'].', '.$value['first_name'].' '.$value['middle_name'],'',0,'C',0);
	// 	$pdf->Cell(25,6,$value['date_long'],'',0,'C',0);
	// 	$pdf->Cell(30,6,$timelongs,'',0,'C',0);
	// 	$pdf->Cell(25,6,$value['schedule'],'',0,'C',0);
	// 	$pdf->Cell(20,6,$timein,'',0,'C',0);
	// 	$pdf->Cell(20,6,$timeout,'',0,'C',0);
	// 	$pdf->Cell(20,6,$value['hrs'],'',0,'C',0);
	// 	$pdf->Cell(20,6,$value['tardiness'],'',0,'C',0);
	// 	$pdf->Cell(20,6,$value['undertime'],'',0,'C',0);
	// 	$pdf->Cell(20,6,$value['overtime'],'',0,'C',0);
	// 	$pdf->Cell(25,6,$value['suspension'],'',0,'C',0);
	// 	$pdf->Cell(20,6,$value['status'],'',0,'C',0);
	// 	$pdf->Ln();
	// 	}
	// }
	// print_r($sum);


	$pdf->Ln();
	$pdf->Ln();
	$pdf->Ln();
	$pdf->Ln();


	$pdf->SetFont('Arial', 'B', 14);
	$pdf->Cell(600,10,'______________________________','',0,'C',0);
	$pdf->Ln();
	$pdf->Cell(334,10,'Signature over printed name','','C',0);
	$pdf->Ln();



	// $pdf->Cell(295,6,$namesvisor,'',0,'R',0);
	$pdf->Output();


?>