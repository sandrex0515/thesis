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
        
        public function addProd($data){
            foreach($data as $k=>$v){
                $this->$k = pg_escape_string(strip_tags(trim($v)));
            }

            $sql = <<<EOT
            with at as (
                insert into itempic
                (
                    path,
                    pic_id
                    )
                    values(
                        '$this->profimg',
                        $this->stock_id
                        )
                    ), b as(
                        insert into stock(
                        stock_id,
                        quantity
                        )
                        values(
                            $this->stock_id,
                            $this->stock
                            )
                            )
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
//         public function addStock(){ 

//             $sql = <<<EOT
//                 insert into stock
//                 ( 
//                     stock_id,
//                     quantity
//                 )
//                values
//                (
//                    $this->stock_id,
//                    $this->stock
//                    )
// EOT;
//         return ClassParent::insert($sql);
// }
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
        public function temp($data){
                foreach($data as $k=>$v){
                    $this->$k = pg_escape_string(strip_tags(trim($v)));
                }
            $sql = <<<EOT
            with a as (
                    delete from temp where pk = $this->pk
             )
           ,b as (
                    insert into temp(
                        pk,
                        search
                        )
                        values(
                            $this->pk,
                            '$this->searchString'
                            )
                            )
                            select * from temp where pk = $this->pk
                    
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

        public function fetchsearch($data){
            foreach($data as $k=>$v){
                $this->$k = pg_escape_string(strip_tags(trim($v)));
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
            (select search from temp where pk = $this->pk) as search,
            itempic.path
            from
            item
            inner join stock
            on item.item_id = stock.stock_id
            inner join itempic
            on item.item_id = itempic.pic_id
           
            where item = (select search from temp where pk = $this->pk)
                
EOT;
            return ClassParent::get($sql);
        }

        public function cart($data){
            foreach($data as $k=>$v){
                $this->$k = pg_escape_string(strip_tags(trim($v)));
            }
            $sql = <<<EOT

                insert into cart(
                    ord_id,
                    quantity,
                    pk
                    )
                    values(
                        $this->item_id,
                        $this->quantity,
                        $this->pk
                        )

EOT;
            return ClassParent::insert($sql);
        }

        public function cartfetch($data){
            foreach($data as $k => $v){
                $this->$k = pg_escape_string(strip_tags(trim($v)));
            }

            $sql = <<<EOT
                    select 
                    *
                    from cart
                    inner join item
                    on cart.ord_id = item.item_id
                    inner join itempic
                    on itempic.pic_id = item.item_id
                    where pk = $this->pk
                    order by cdate desc
                    
EOT;
            return ClassParent::get($sql);
        }

        public function delcart($data){
            foreach($data as $k=>$v){
                $this->$k = pg_escape_string(strip_tags(trim($v)));
            }
            $sql = <<<EOT
            delete from
            cart 
            where
            cartpk = $this->cartpk

EOT;
            return ClassParent::insert($sql);
        }

        public function ord($data){
            foreach($data as $k=>$v){
                $this->$k = pg_escape_string(strip_tags(trim($v)));
            }
            $sql = <<<EOT
            with a as(
                delete from 
                cart where
                cartpk = $this->cartpk
                )
                insert into pending
                (
                pending_pk,
                p_id,
                quantity
                )
                values
                (
                $this->pk,
                $this->item_id,
                $this->quantity
                )
EOT;
            return ClassParent::insert($sql);
        }
        public function pending($data){
            $filter = $data['searchString'];
            $type= $data['type'];
            $where = "";
            $where1 = "";
            if($filter){
                $where .= "AND tbluser.name ILIKE '%".$filter."%'";
            }
            if($type == 'Date'){
                $where1 .="ORDER BY ord_date ASC";  
            }else if($type == 'Name'){
                $where1 .="ORDER BY tbluser.name ASC";
            }else if($type == 'Place'){
                $where1 .="ORDER BY tbluser.address ASC";
            }else{
                $where1 .="ORDER BY ord_date DESC";
            }
            foreach($data as $k=>$v){
                $this->$k = pg_escape_string(strip_tags(trim($v)));
            }

            $sql = <<<EOT
                select * from
                pending 
                inner join tbluser
                on pending.pending_pk = tbluser.pk
                inner join itempic 
                on pending.p_id = itempic.pic_id
                inner join item
                on pending.p_id = item.item_id
                where arv = false
                $where
                $where1
                
EOT;
            return ClassParent::get($sql);

        }

        public function delivery($data){
            foreach($data as $k=>$v){
                $this->$k = pg_escape_string(strip_tags(trim($v)));
            }
            $sql = <<<EOT
            with a as(
                insert into delivery
                (
                    delivery_id,
                    delivery_pk,
                    delivery_pic,
                    quantity
                )
                values
                (
                    $this->pending_id,
                    $this->pk,
                    $this->pic_id,
                    $this->quantity
                    )
                )
                delete from pending where 
                pending_id = $this->pending_id
EOT;
            return CLassParent::insert($sql);
        }
        public function fetchdelivery($data){
            $filter = $data['searchString'];
            $type= $data['type'];
            $where = "";
            $where1 = "";
            if($filter){
                $where .= "AND tbluser.name ILIKE '%".$filter."%'";
            }
            if($type == 'Date'){
                $where1 .="ORDER BY delivery_date ASC";  
            }else if($type == 'Name'){
                $where1 .="ORDER BY tbluser.name ASC";
            }else if($type == 'Place'){
                $where1 .="ORDER BY tbluser.address ASC";
            }else{
                $where1 .="ORDER BY delivery_date DESC";
            }
            foreach($data as $k=>$v){
                $this->$k = pg_escape_string(strip_tags(trim($v)));
            }

            $sql = <<<EOT
                select * from
                delivery 
                inner join tbluser
                on delivery.delivery_pk = tbluser.pk
                inner join itempic 
                on delivery.delivery_pic = itempic.pic_id
                inner join item
                on delivery.delivery_pic = item.item_id
                where arc = false
                $where
                $where1
                
EOT;
            return ClassParent::get($sql);

        }

        public function deliverydelete($data){
            foreach($data as $k=>$v){
                $this->$k = pg_escape_string(strip_tags(trim($v)));
            }
            $sql = <<<EOT
                delete from 
                delivery
                where 
                delivery_id = $this->delivery_id
EOT;
            return ClassParent::insert($sql);
        }

        public function delivered($data){
            foreach($data as $k=>$v){
                $this->$k = pg_escape_string(strip_tags(trim($v)));
            }
            $sql = <<<EOT
            with a as(
                insert into delivered
                (
                    delivered_id,
                    delivered_pk,
                    delivered_pic,
                    quantity
                )
                values
                (
                    $this->delivery_id,
                    $this->delivery_pk,
                    $this->pic_id,
                    $this->quantity
                    )
                ), b as(
                    update stock set quantity = 
                    (select quantity from stock where stock_id = $this->delivery_pic) - 1 
                    where stock_id = $this->delivery_pic
                    )

                delete from delivery where 
                d_id = $this->d_id
EOT;
            return CLassParent::insert($sql);
        }
        public function fetchdelivered($data){
            $filter = $data['searchString'];
            $type= $data['type'];
            $where = "";
            $where1 = "";
            if($filter){
                $where .= "AND tbluser.name ILIKE '%".$filter."%'";
            }
            if($type == 'Date'){
                $where1 .="ORDER BY delivered_date ASC";  
            }else if($type == 'Name'){
                $where1 .="ORDER BY tbluser.name ASC";
            }else if($type == 'Place'){
                $where1 .="ORDER BY tbluser.address ASC";
            }else{
                $where1 .="ORDER BY delivered_date DESC";
            }
            foreach($data as $k=>$v){
                $this->$k = pg_escape_string(strip_tags(trim($v)));
            }

            $sql = <<<EOT
                select * from
                delivered 
                inner join tbluser
                on delivered.delivered_pk = tbluser.pk
                inner join itempic 
                on delivered.delivered_pic = itempic.pic_id
                inner join item
                on delivered.delivered_pic = item.item_id
                where arc = false
                $where
                $where1
                
EOT;
            return ClassParent::get($sql);

        }
        public function csv(){
            $sql = <<<EOT
                select * from delivery
                inner join tbluser
                on delivery.delivery_pk = tbluser.pk
                inner join item
                on delivery.delivery_pic = item_id
EOT;
            return ClassParent::get($sql);
        }
        public function csv2(){
            $sql = <<<EOT
                select * from delivered
                inner join tbluser
                on delivered.delivered_pk = tbluser.pk
                inner join item
                on delivered.delivered_pic = item_id
EOT;
            return ClassParent::get($sql);
        }

        public function pdf(){
            $sql = <<<EOT
                select * from delivery
                inner join tbluser
                on delivery.delivery_pk = tbluser.pk
                inner join item
                on delivery.delivery_pic = item_id
EOT;
            return ClassParent::get($sql);
        }
        
        public function getcat(){
            $sql = <<<EOT
            select * from categories_item
           
            order by cat_name ASC
            
EOT;
            return ClassParent::get($sql);
        }

        public function addcateg($data){
            foreach($data as $k=>$v){
                $this->$k = pg_escape_string(strip_tags(trim($v)));
            }
            $sql = <<<EOT

                insert into categories(
                    name,
                    cat_path
                    
                    )
                    values(
                        '$this->name',
                        '$this->profimg'
                        )

EOT;
            return ClassParent::insert($sql);
        }
        public function addsubcateg($data){
            foreach($data as $k=>$v){
                $this->$k = pg_escape_string(strip_tags(trim($v)));
            }
            $sql = <<<EOT

                insert into categories_item(
                    cat_name,
                    path,
                    cat_subitem
                    )
                    values(
                        '$this->name',
                        '$this->profimg',
                        '$this->category'
                        )

EOT;
            return ClassParent::insert($sql);
        }
        public function fetchcateg(){
            $sql = <<<EOT
            select 
            cat_id,
            name,
            date::timestamp(0),
            cat_path
            from categories
            
EOT;
            return ClassParent::get($sql);
        }

        public function getsub($data){
            foreach($data as $k=>$v){
                $this->$k = pg_escape_string(strip_tags(trim($v)));
            }
            $sql = <<<EOT
            select 
            *
            from categories_item
            where cat_subitem = '$this->name'
            
EOT;
            return ClassParent::get($sql);
        }
        
        public function getsub2($data){
            foreach($data as $k=>$v){
                $this->$k = pg_escape_string(strip_tags(trim($v)));
            }
            $sql = <<<EOT
            select 
            *
            from categories_item
            inner join item
            on categories_item.cat_name = item.type
            where cat_subitem = '$this->cat_subitem'
            
EOT;
            return ClassParent::get($sql);
        }

       
}



?>
