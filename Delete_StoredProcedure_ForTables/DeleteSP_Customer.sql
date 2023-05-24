--- Delete Operation for Customer Table ---


CREATE PROCEDURE spDeleteOperation_Customer
  @jsonInput NVARCHAR(MAX)
AS
BEGIN
  SET XACT_ABORT ON;
  BEGIN TRY
    BEGIN TRANSACTION;

    -- Delete the customer from the Customer table using the provided JSON data
    DELETE FROM Customer
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
  "Customer_id": 100
}';

EXEC spDeleteOperation_Customer @jsonInput = @jsonData;


