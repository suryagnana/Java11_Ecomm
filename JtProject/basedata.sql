# SQL configs
SET SQL_MODE ='IGNORE_SPACE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

# create database and use it
DROP DATABASE IF EXISTS ecommjava;
CREATE DATABASE IF NOT EXISTS ecommjava;
USE ecommjava;

# create the category table
CREATE TABLE IF NOT EXISTS CATEGORY(
category_id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(255) NULL
) ENGINE=InnoDB;

# insert default categories
INSERT INTO CATEGORY(name) VALUES ('Fruits'),
                                  ('Vegetables'),
                                  ('Meat'),
                                  ('Fish'),
                                  ('Dairy'),
                                  ('Bakery'),
                                  ('Drinks'),
                                  ('Sweets'),
                                  ('Other');

# create the customer table
CREATE TABLE IF NOT EXISTS CUSTOMER(
id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
address VARCHAR(255) NULL,
email VARCHAR(255) NULL,
password VARCHAR(255) NULL,
role VARCHAR(255) NULL,
username VARCHAR(255) NULL,
UNIQUE (username)
) ENGINE=InnoDB;

# insert default customers
INSERT INTO CUSTOMER(address, email, password, role, username) VALUES
                                                                   ('123, Albany Street', 'admin@nyan.cat', '123', 'ROLE_ADMIN', 'admin'),
                                                                   ('765, 5th Avenue', 'lisa@gmail.com', '765', 'ROLE_NORMAL', 'lisa');

# create the product table
CREATE TABLE IF NOT EXISTS PRODUCT(
product_id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
description VARCHAR(255) NULL,
image VARCHAR(255) NULL,
name VARCHAR(255) NULL,
price int NULL,
quantity int NULL,
weight int NULL,
category_id int NULL,
customer_id int NULL,
FOREIGN KEY (category_id) REFERENCES CATEGORY(category_id),
FOREIGN KEY (customer_id) REFERENCES CUSTOMER(id)
) ENGINE=InnoDB;

# insert default products
INSERT INTO PRODUCT(description, image, name, price, quantity, weight, category_id) VALUES
                                                                                        ('Fresh and juicy', 'https://freepngimg.com/save/9557-apple-fruit-transparent/744x744', 'Apple', 3, 40, 76, 1),
                                                                                        ('Woops! There goes the eggs...', 'https://www.nicepng.com/png/full/813-8132637_poiata-bunicii-cracked-egg.png', 'Cracked Eggs', 1, 90, 43, 9);

# create cart table
CREATE TABLE IF NOT EXISTS cart(
id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
customer_id int NOT NULL,
FOREIGN KEY (customer_id) REFERENCES CUSTOMER(id)
) ENGINE=InnoDB;

# create cart_product join table
CREATE TABLE IF NOT EXISTS cart_product(
id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
cart_id int NOT NULL,
product_id int NOT NULL,
quantity int NOT NULL DEFAULT 1,
FOREIGN KEY (cart_id) REFERENCES cart(id),
FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id)
) ENGINE=InnoDB;