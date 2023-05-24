--- Creating Tables for Database ---


1)Product

CREATE TABLE Product(
Product_id INT PRIMARY KEY,
Name VARCHAR(100),
Description VARCHAR(300),
Price DECIMAL(6,2),
RemainingInStock INT
);


2)Customer

CREATE TABLE Customer(
Customer_id INT PRIMARY KEY,
Fullname VARCHAR(60),
Email VARCHAR(60) UNIQUE,
PhoneNo NUMERIC(14,0)  UNIQUE,
);


3)Invoice

CREATE TABLE Invoice(
Invoice_id INT IDENTITY(1,1) PRIMARY KEY,
Customer_id INT,
TotalBill DECIMAL(8,2),
IssuedDate DATE,
CONSTRAINT fki_Customer_id FOREIGN KEY (Customer_id) 
REFERENCES Customer(Customer_id) ON DELETE CASCADE 
);


4)STransaction

CREATE TABLE STransaction (
Transaction_id INT PRIMARY KEY,
Customer_id INT,
Product_id INT,
Quantity INT,
UnitPrice DECIMAL(6,2),
TotalAmount DECIMAL(8,2),
Invoice_id INT,
CONSTRAINT fkt_Customer_id FOREIGN KEY (Customer_id) 
REFERENCES Customer(Customer_id) ON DELETE NO ACTION,
CONSTRAINT fkt_Product_id FOREIGN KEY (Product_id) 
REFERENCES Product(Product_id) ON DELETE CASCADE,
CONSTRAINT fkt_Invoice_id FOREIGN KEY (Invoice_id) 
REFERENCES Invoice(Invoice_id) ON DELETE CASCADE
);
