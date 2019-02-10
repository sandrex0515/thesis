<?php
require_once('../../php/CLASSES/ClassParent.php');


class addPod extends ClassParent{

    var $name = null;
    var $descript = null;
    var $price = null;
    var $category = null;

        public function __construct(

            $name,
            $descript,
            $price,
            $category
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
        
        public function addProd(){
            $sql = <<<EOT
            insert into item
            
                (item,description,price,type)
            values(
               '$this->name', 
            '$this->descript',
            $this->price,
            '$this->category'
          )
EOT;
        return ClassParent::insert($sql);
}
}



?>