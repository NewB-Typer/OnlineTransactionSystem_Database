--- Update Operation for table Customer ---


CREATE PROCEDURE spUpdateOperation_Customer
  @jsonInput NVARCHAR(MAX)
AS
BEGIN
  SET XACT_ABORT ON;
  BEGIN TRY
    BEGIN TRANSACTION;

    -- Temporarily stores the updated customer 
    DECLARE @UpdatedCustomers TABLE
    (
      Customer_id INT PRIMARY KEY,
      Fullname VARCHAR(60),
      Email VARCHAR(60),
      PhoneNo NUMERIC(14, 0)
    );

    -- Updating the Customer
    UPDATE Customer
    SET
      Fullname = JSON_VALUE(@jsonInput, '$.Fullname'),
      Email = JSON_VALUE(@jsonInput, '$.Email'),
      PhoneNo = JSON_VALUE(@jsonInput, '$.PhoneNo')
    OUTPUT
      INSERTED.Customer_id,
      INSERTED.Fullname,
      INSERTED.Email,
      INSERTED.PhoneNo
    INTO @UpdatedCustomers
    WHERE
      Customer_id = JSON_VALUE(@jsonInput, '$.Customer_id');

       COMMIT;
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0
      ROLLBACK;

    THROW;
  END CATCH;
END



-- Execution Code

DECLARE @jsonData NVARCHAR(MAX);
SET @jsonData = '{
  "Customer_id": 102 ,
  "Fullname": "John Cena",
  "Email": "yuoae90@gmail.com",
  "PhoneNo": 9809373281
}';

EXEC spUpdateOperation_Customer @jsonInput = @jsonData;
