--- Delete Operation for STransaction Operation ---



CREATE PROCEDURE spDeleteOperation_STransaction
  @jsonInput NVARCHAR(MAX)
AS
BEGIN
  SET XACT_ABORT ON;
  BEGIN TRY
    BEGIN TRANSACTION;

    -- Delete the transaction from the STransaction table using the provided JSON data
    DELETE FROM STransaction
    WHERE
      Transaction_id = JSON_VALUE(@jsonInput, '$.Transaction_id');

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
  "Transaction_id": 501
}';

EXEC spDeleteOperation_STransaction @jsonInput = @jsonData;

