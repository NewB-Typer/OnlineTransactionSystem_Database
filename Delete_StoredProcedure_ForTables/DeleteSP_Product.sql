--- Delete Operation for Product Table ---

CREATE PROCEDURE spDeleteOperation_Product
  @jsonInput NVARCHAR(MAX)
AS
BEGIN
  SET XACT_ABORT ON;
  BEGIN TRY
    BEGIN TRANSACTION;

    -- Delete the product using the provided JSON data
    DELETE FROM Product
    WHERE
      Product_id = JSON_VALUE(@jsonInput, '$.Product_id');

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
  "Product_id": 10
}';

EXEC spDeleteOperation_Product @jsonInput = @jsonData;

