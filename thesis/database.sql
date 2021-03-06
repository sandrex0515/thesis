create database thesis;

grant usage, select on all sequences in schema public to sandrex;

create table profile(
    id serial primary key,
    name varchar(255) NOT NULL,
    password varchar(255) NOT NULL,
    email varchar(255) NOT NULL,
    address varchar(255) NOT NULL,
    contact varchar(255) NOT NULL
);

create table admin(
    id serial primary key,
    name varchar(255) NOT NULL,
    password varchar(255) NOT NULL,
    email varchar(255) NOT NULL,
    address varchar(255) NOT NULL,
    contact varchar(255) NOT NULL
);

create table adminpic(
    id int references profile(id),
    path varchar(255) NOT NULL
);

create table userpic(
    id int references profile(id),
    path varchar(255) NOT NULL
);
alter table userpic drop column id;
alter table userpic add column user_id numeric;
alter table userpic owner to sandrex;

create table item(
    id serial primary key,
    item varchar(255) unique NOT NULL,
    description varchar(255) NOT NULL,
    price numeric NOT NULL,
    type varchar(255) NOT NULL,
    item_id numeric unique NOT NULL,
    create_at timestamp with time zone DEFAULT NOW();
);
alter table item add column archived boolean default false;

create table itempic(
    id int references item(id),
    path varchar(255) NOT NULL,
    date date
);
alter table itempic drop column id;
alter table itempic drop column date;
alter table itempic add column pic_id numeric;
alter table itempic add column date timestamp with time zone default now();
alter table itempic owner to sandrex;
alter table itempic add column main text;

create table stock(
    -- id int references item(id),
    stock_id numeric,
    quantity numeric
);

create table cart(
    id serial primary key,
    item varchar(255) NOT NULL,
    price numeric NOT NULL,   
    ord_id numeric  NOT NULL
);
alter table cart drop column price;
alter table cart drop column item;
alter table cart add column quantity numeric;
alter table cart add column date time default now();
alter table cart drop column id;
alter table cart add column pk numeric;
alter table cart rename column "date" to "cdate";
alter table cart add column id serial primary key;
alter table cart rename column "id" to "cartpk";
alter table cart owner to sandrex;


create table pending(
    pending_id serial primary key,
    pending_pk numeric, item_id numeric,
    quantity numeric, ord_date timestamp, 
    pending_pic varchar, 
    archived boolean default false
);
alter table pending owner to sandrex;
alter table pending drop column ord_date;
alter table pending drop column pending_pic;
alter table pending add column ord_date timestamp default now();
alter table pending rename column "item_id" to "p_id";
alter table pending rename column "archived" to "arv";

create table delivery
(
    delivery_id numeric,
    delivery_date timestamp default now()
    );
    alter table delivery owner to sandrex;
    alter table delivery add column arc boolean default false;
    alter table delivery add column delivery_pk numeric;
    alter table delivery add column delivery_pic varchar;
    alter table delivery drop column delivery_pic;
    alter table delivery add column delivery_pic numeric;
    alter table delivery add column d_id serial primary key;
    alter table delivery add column quantity numeric;




create table delivered
(
    delivered_id numeric,
    delivered_date timestamp default now()
    );
    alter table delivered owner to sandrex;
    alter table delivered add column arc boolean default false;
    alter table delivered add column delivery_pk numeric;
    alter table delivered add column delivery_pic varchar;
    alter table delivered drop column delivery_pic;
    alter table delivered add column delivery_pic numeric;
    alter table delivered add column d_id serial primary key;
    alter table delivered rename column "delivery_pk" to "delivered_pk";
    alter table delivered rename column "delivery_pic" to "delivered_pic";
    alter table delivered add column quantity numeric;

create table checked(
    name varchar(255) NOT NULL,
    item varchar(255) NOT NULL,
    price varchar(255) NOT NULL,
    address varchar(255) NOT NULL,
    contact varchar(255) NOT NULL
);
   
   create table recom(
       date timestamp default now(), 
        rec_id varchar
   );

create table delivered(
    name varchar(255) NOT NULL,
    item varchar(255) NOT NULL,
    price varchar(255) NOT NULL,
    address varchar(255) NOT NULL,
    contact varchar(255) NOT NULL
);
alter table delivered add column date timestamp with time zone default now();
alter table delivered add column ord_id numeric unique not null;

    create table tbluser(
    id serial primary key, 
    name text unique not null, 
    bday varchar, 
    gender text, 
    address varchar, 
    email varchar, 
    password varchar
    );
    alter table tbluser owner to sandrex;
    alter table tbluser add column created_at timestamp with time zone default now();
    alter table tbluser add column archived boolean default false;
    create unique index constraint_name on tbluser (email);
    alter table tbluser add column contact varchar not null;
    alter table tbluser add column pk serial;

create table sales(
    id serial primary key,
    sales numeric,
    year numeric
);
alter table sales add column sales_date timestamp default now();
alter table sales owner to sandrex;
alter table sales drop column sales_date;
alter table sales add column sales_date timestamp default now() unique;

create table analytics(id serial primary key, 
year varchar, 
January varchar,
 February varchar, 
 March varchar, 
 April varchar, 
 May varchar, 
 June varchar, 
 July varchar, 
 August varchar, 
 September varchar, 
 October varchar, 
 November varchar, 
 December varchar
 );
alter table analytics owner to sandrex;

create table recommend(
item_id int references item(item_id), 
date timestamp with time zone default now()
);  
alter table recommend drop column item_id;
alter table recommend add column item_id;
alter table recommend drop column item_id;
alter table recommend add column rec_id numeric unique;

create table search(
    id numeric, 
    views numeric
    );
alter table search owner to sandrex;
alter table search drop column id;
alter table search add column id numeric unique;
alter table search add column id_search numeric unique;

create table brand(
    rand_id numeric, 
    brand_name varchar unique
    );
alter table brand owner to sandrex;

create table categories(
    cat_id serial primary key, 
    cat_name varchar, 
    cat_sub jsonb
    );
    alter table categories owner to sandrex;
    alter table categories add column date timestamp default now();
    alter table categories add column cat_path varchar;
    alter table categories rename column "cat_name" to "name";


    create table categories_item(
        cat_item_id numeric, 
        cat_name varchar
        );
        alter table categories_item owner to sandrex;
        alter table categories_item add column path varchar;
        alter table categories_item add column cat_date timestamp default now();
        alter table categories_item drop column cat_item_id;
        alter table categories_item add column cat_subitem_id serial primary key;
        alter table categories_item add column cat_subitem varchar;

        
create table temp(
    pk numeric, 
    search varchar
    );
    alter table temp owner to sandrex;


    $scope.export_pdf = function () {

        var filters = [];
        if ($scope.filter.department[0]) {
            filters.push('&departments_pk=' + $scope.filter.department[0].pk);
        }

        if ($scope.filter.level_title[0]) {
            filters.push('&levels_pk=' + $scope.filter.level_title[0].pk);
        }

        if ($scope.filter.titles[0]) {
            filters.push('&titles_pk=' + $scope.filter.titles[0].pk);
        }
        $scope.image = "dsadasdasda";

        window.open('./FUNCTIONS/Employees/employeelist_export_pdf.php?&imagess=' + $scope.image + '&status=Active' + filters.join(''));

    }
    $scope.export_excel_attrition = function () {



    }
    $scope.export_employeelist = function () {
        var filters = [];
        if ($scope.filter.department[0]) {
            filters.push('&departments_pk=' + $scope.filter.department[0].pk);
        }

        if ($scope.filter.level_title[0]) {
            filters.push('&levels_pk=' + $scope.filter.level_title[0].pk);
        }

        if ($scope.filter.titles[0]) {
            filters.push('&titles_pk=' + $scope.filter.titles[0].pk);
        }

        window.open('./FUNCTIONS/Employees/employeelist_export.php?&status=Active' + filters.join(''));

    }





<?php
require_once('../connect.php');
require_once('../../CLASSES/Employees.php');

$class = new Employees(
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL
					);

$data = $class->auth($_POST);

header("HTTP/1.0 404 User Not Found");
if($data['status']){
	$pk = md5('pk'); 
	setcookie($pk, md5($data['result'][0]['pk']), time()+7200000, '/');
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>



