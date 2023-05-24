--- Create(Insert) Operation for Customer Table ---



Create Procedure spCreateOPeration_Customer
  @jsonData NVARCHAR(MAX)
AS
BEGIN
  SET XACT_ABORT ON;
  BEGIN TRY
    BEGIN TRANSACTION;
    DECLARE 
           @CustomerId INT,
            @CustomerName NVARCHAR(100),
            @CustomerEmail NVARCHAR(100),
            @CustomerPhone NUMERIC(14,0);
    SELECT
      @CustomerId = JSON_VALUE(@jsonData, '$.Customer_id'),
      @CustomerName = JSON_VALUE(@jsonData, '$.Fullname'),
      @CustomerEmail = JSON_VALUE(@jsonData, '$.Email'),
      @CustomerPhone = JSON_VALUE(@jsonData, '$.PhoneNo');
   INSERT INTO Customer(Customer_id, Fullname, Email, PhoneNo)   VALUES (@CustomerId,@CustomerName,@CustomerEmail,@CustomerPhone);

    COMMIT;
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0
      ROLLBACK;
    THROW;
  END CATCH;
END




-- Execution code
DECLARE @jsonData NVARCHAR(MAX);
SET @jsonData = '{"Customer_id": 110,
 "Fullname": "Mark Twain",
 "Email": "Someday010@yahoo.com",
 "PhoneNo": 9879802719}';

EXEC spCreateOPeration_Customer @jsonData;
