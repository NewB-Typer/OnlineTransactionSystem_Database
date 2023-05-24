--- Stored Procedure to return the total invoice bill within date range


CREATE PROCEDURE spGetCustomerInfoBill
    @json NVARCHAR(MAX)
AS 
BEGIN
    DECLARE @CustomerID INT,
            @Start_Date DATE,
            @End_Date DATE

    SELECT
        @CustomerID = Customer_id,
        @Start_Date = IssuedDate,
        @End_Date = IssuedDate
    FROM OPENJSON(@json)
    WITH
    (
        CustomerID INT '$.CustomerID',
        Start_Date DATE '$.Start_Date',
        End_Date DATE '$.End_Date'
    )

    IF @CustomerID IS NULL
    BEGIN
        SELECT *
        FROM Customer c
        INNER JOIN Invoice i ON c.Customer_Id = i.Customer_id
        WHERE i.IssuedDate >= @Start_Date
          AND i.IssuedDate <= @End_Date
    END
    ELSE
    BEGIN
        SELECT c.*, i.TotalBill AS TotalBill
        FROM Customer c
        INNER JOIN Invoice i ON c.Customer_id = i.Customer_id
        WHERE c.Customer_id = @CustomerID
          AND i.IssuedDate >= @Start_Date
          AND i.IssuedDate <= @End_Date
    END
END


 

--- Execution Code

DECLARE @json NVARCHAR(MAX) = '{
  "CustomerID": 100,
  "Start_Date": "2022-01-01",
  "End_Date": "2023-12-31"}';

EXEC proGetCustomerInfoInvoiceBill @json;
