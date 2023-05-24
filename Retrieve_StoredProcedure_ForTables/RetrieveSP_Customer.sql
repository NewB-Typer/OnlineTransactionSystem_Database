--- Retrieve(Select) Operation for table Customer  ---



CREATE PROCEDURE spRetrieveCustomer
    @jsonData NVARCHAR(MAX)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        DECLARE @CustomerId INT,
                @FullName VARCHAR(60),
                @Email VARCHAR(60),
                @PhoneNo NUMERIC(14,0);

        
        SELECT @CustomerId = JSON_VALUE(@jsonData, '$.Customer_id'),
               @FullName = JSON_VALUE(@jsonData, '$.Fullname'),
               @Email = JSON_VALUE(@jsonData, '$.Email'),
               @PhoneNo = JSON_VALUE(@jsonData, '$.PhoneNo');

        
        SELECT *
        FROM Customer
        WHERE (Customer_id = @CustomerId OR @CustomerId IS NULL)
          AND (FullName = @FullName OR @FullName IS NULL)
          AND (Email = @Email OR @Email IS NULL)
          AND (PhoneNo = @PhoneNo OR @PhoneNo IS NULL);

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        
        THROW;
    END CATCH;
END



--Execution code

DECLARE @jsonData NVARCHAR(MAX) = '{"Customer_id": 100}';
EXEC spRetrieveCustomer @jsonData = @jsonData;

