<?php
require_once('../../php/CLASSES/ClassParent.php');


class addPod extends ClassParent{

    var $item_id = null;
        public function __construct(

            $item_id

        ){
            $stock_id = rand(1000000,9000000);
            $fields = get_defined_vars();
            
            if(empty($fields)){
                return(FALSE);
            }
            foreach($fields as $k=>$v){
                $this->$k = pg_escape_string(trim(strip_tags($v)));
            }
            return(TRUE);
        }
        
        
        public function delprod(){
            $sql = <<<EOT
                delete  
                from 
                item
                using stock
                where item.item_id = $this->item_id
                AND stock.stock_id = $this->item_id
EOT;
        return ClassParent::insert($sql);
        }
}



?>