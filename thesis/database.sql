create database thesis;

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
    item varchar(255) NOT NULL,
    description varchar(255) NOT NULL,
    stock numeric NOT NULL,
    price numeric NOT NULL,
    type varchar(255) NOT NULL
);

create table itempic(
    id int references item(id),
    path varchar(255) NOT NULL,
    date date
);

create table stock(
    id int references item(id),
    quantity numeric
);

create table cart(
    id int references profile(id),
    item varchar(255) NOT NULL,
    price numeric NOT NULL    
);

create table pending(
    name varchar(255) NOT NULL,
    item varchar(255) NOT NULL,
    price varchar(255) NOT NULL,
    address varchar(255) NOT NULL,
    contact varchar(255) NOT NULL
);

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
create table delivered(
    name varchar(255) NOT NULL,
    item varchar(255) NOT NULL,
    price varchar(255) NOT NULL,
    address varchar(255) NOT NULL,
    contact varchar(255) NOT NULL
);

create table sales(
    id serial primary key,
    sales numeric,
    year numeric
);