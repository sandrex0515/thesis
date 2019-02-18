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

create table item(
    id serial primary key,
    item varchar(255) unique NOT NULL,
    description varchar(255) NOT NULL,
    price numeric NOT NULL,
    type varchar(255) NOT NULL,
    item_id numeric unique NOT NULL,
    create_at timestamp with time zone DEFAULT NOW();
);

create table itempic(
    id int references item(id),
    path varchar(255) NOT NULL,
    date date
);

create table stock(
    -- id int references item(id),
    stock_id numeric,
    quantity numeric
);

create table cart(
    id int references profile(id),
    item varchar(255) NOT NULL,
    price numeric NOT NULL,   
    ord_id numeric unique NOT NULL
);

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