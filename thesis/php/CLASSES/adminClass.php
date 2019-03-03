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
        public function Searchview(){
            $sql = <<<EOT
            insert into search
            (
                id,
                views
            )
            values
            (
                $this->stock_id,
                0
            )
EOT;
        return ClassParent::insert($sql);
        }

        public function fetch($data){
            $filter = $data['searchString'];
            $type= $data['type'];
            $where = "";
            $where1 = "";
            if($filter){
                $where .= "AND item ILIKE '%".$filter."%'";
            }
            if($type == 'Date'){
                $where1 .="ORDER BY created_at DESC";  
            }else if($type == 'Title'){
                $where1 .="ORDER BY item ASC";
            }else if($type == 'Price'){
                $where1 .="ORDER BY price DESC";
            }else if($type == 'Category'){
                $where1 .="ORDER BY type ASC";
            }else{
                $where1 .="ORDER BY created_at DESC";
            }

            $sql = <<<EOT
                select
                id,
                description,
                price,
                type,
                item_id,
                created_at::timestamp(0),
                item,
                stock.quantity,
                itempic.path
                from
                item
                inner join stock
                on item.item_id = stock.stock_id
                inner join itempic
                on item.item_id = itempic.pic_id
                
                where archived = false
                $where
                $where1

               
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
        public function recommend(){
            $sql = <<<EOT
            insert into recommend
            (
                item_id
            )
            values
            (
                $this->item_id
            )
EOT;
            return ClassParent::insert($sql);

        }
        public function register($data){
            $pass = $data['password'];
        
          
         
            $password = hash('sha256', $pass);
            foreach($data as $k=>$v){
                $this->$k = pg_escape_string(trim(strip_tags($v)));
            }

            $sql = <<<EOT
            with tbluser as(
                insert into tbluser
                (
                    name,
                    bday,
                    gender,
                    email,
                    password,
                    contact,
                    address

                )
                values
                (
                    '$this->name',
                    '$this->bdate',
                    '$this->gender',
                    '$this->email',
                    '$password',
                    '$this->contact',
                    '$this->address'

                )
                returning id
                )
                    insert into userpic
                    (
                        user_id,
                        path
                        )
                        values(
                            (select id from tbluser),
                             '$this->prof'
                             )            
EOT;
                return ClassParent::insert($sql);
        }
        public function login($data){
            $pass = $data['password'];
        
          
            $password = hash('sha256', $pass);
            foreach($data as $k=>$v){
                $this->$k = pg_escape_string(strip_tags(trim($v)));
            }
            $sql = <<<EOT
                select * 
                from tbluser 
                where
                email = '$this->email' 
                AND
                password = '$password'
EOT;
    return ClassParent::get($sql);

        }
        public function get_info($pk){
            
     
            $sql = <<<EOT
                    select * 

                    from
                    tbluser 
                    inner join userpic
                    on tbluser.id = userpic.user_id
                    where
                    pk = $pk
                     
                    
EOT;
            return ClassParent::get($sql);
        }
}



?>