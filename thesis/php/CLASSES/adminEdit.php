<?php
require_once('../../php/CLASSES/ClassParent.php');


class addedit extends ClassParent{

    var $id = null;
    var $description = null;
    var $price = null;
    var $type = null;
    var $item_id = null;
    var $item = null;
    var $quantity = null;
        public function __construct(
            $id,
            $description,
            $price,
            $type,
            $item_id,
            $item,
            $quantity

        ){
           
            $fields = get_defined_vars();
            
            if(empty($fields)){
                return(FALSE);
            }
            foreach($fields as $k=>$v){
                $this->$k = pg_escape_string(trim(strip_tags($v)));
            }
            return(TRUE);
        }
        
        
        public function editprod(){
            $sql = <<<EOT
                update 
                item set
                item = '$this->item', description = '$this->description', price = $this->price, type = '$this->type'
                WHERE id = $this->id
EOT;
            return ClassParent::update($sql);

        }
        public function editstock(){
            $sql = <<<EOT
            update 
            stock set
            quantity = $this->quantity
             WHERE stock_id = $this->item_id
EOT;
        return ClassParent::update($sql);

        }
}



?>