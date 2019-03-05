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
    name varchar(255) NOT NULL,
    item varchar(255) NOT NULL,
    price varchar(255) NOT NULL,
    address varchar(255) NOT NULL,
    contact varchar(255) NOT NULL
);
alter table pending add column date timestamp with time zone default now();
alter table pending add column ord_id int references cart(ord_id);

create table checked(
    name varchar(255) NOT NULL,
    item varchar(255) NOT NULL,
    price varchar(255) NOT NULL,
    address varchar(255) NOT NULL,
    contact varchar(255) NOT NULL
);

create table delivery(
    name varchar(255) NOT NULL,
    item varchar(255) NOT NULL,
    price varchar(255) NOT NULL,
    address varchar(255) NOT NULL,
    contact varchar(255) NOT NULL
);
    alter table delivery add column date timestamp with time zone default now();
    alter table delivery add column ord_id numeric unique not null;    

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
create table recommend(
item_id int references item(item_id), 
date timestamp with time zone default now()
);  
alter table recommend drop column item_id;
alter table recommend add column item_id;


create table search(
    id numeric, 
    views numeric
    );
alter table search owner to sandrex;
alter table search drop column id;
alter table search add column id numeric unique;
alter table search add column id_search numeric unique;

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



