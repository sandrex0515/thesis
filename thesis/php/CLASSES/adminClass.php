<?php
require_once('../../php/CLASSES/ClassParent.php');


class addPod extends ClassParent{

    var $name = null;
    var $descript = null;
    var $price = null;
    var $stock = null;
    var $category = null;
    var $stock_id = null;
    var $item_id = null;
    var $id = null;
    var $description = null;
    var $item = null;
    var $type = null;
        public function __construct(

            $name,
            $descript,
            $price,
            $stock,
            $category,
            $stock_id,
            $item_id,
            $id,
            $description,
            $type,
            $item

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
        
        public function addProd(){
            $sql = <<<EOT
            insert into item
             (
                item,
                description,
                price,
                type,
                item_id
              )
            values(
            '$this->name', 
            '$this->descript',
             $this->price,
            '$this->category',
            $this->stock_id
          )
EOT;
return ClassParent::insert($sql);

 }
        public function addStock(){ 

            $sql = <<<EOT
                insert into stock
                ( 
                    stock_id,
                    quantity
                )
               values
               (
                   $this->stock_id,
                   $this->stock
                   )
EOT;
        return ClassParent::insert($sql);
}
        public function fetch(){
            $sql = <<<EOT
                select
                id,
                description,
                price,
                type,
                item_id,
                created_at::timestamp(0),
                item,
                stock.quantity
                from
                item
                inner join stock
                on item.item_id = stock.stock_id
                ORDER BY created_at DESC
               
EOT;
      
        return ClassParent::get($sql);
        }
        public function fetchcount(){
            $sql = <<<EOT
            select count(*) as bilang
            from stock where quantity < 1;
EOT;
            return ClassParent::get($sql);
        }

    
  
}



?>