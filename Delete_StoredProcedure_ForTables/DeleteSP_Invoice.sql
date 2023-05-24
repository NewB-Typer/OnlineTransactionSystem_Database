--- Delete Operation for Invoice Table ---


CREATE PROCEDURE spDeleteOperation_Invoice
  @jsonInput NVARCHAR(MAX)
AS
BEGIN
  SET XACT_ABORT ON;
  BEGIN TRY
    BEGIN TRANSACTION;

    -- Delete the invoice using the provided JSON data
    DELETE FROM Invoice
    WHERE
      Invoice_id = JSON_VALUE(@jsonInput, '$.Invoice_id');

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
  "Invoice_id": 100}';

EXEC spDeleteOperation_Invoice @jsonInput = @jsonData;
