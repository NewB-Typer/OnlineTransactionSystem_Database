--- Update Operation for Product Table --


CREATE PROCEDURE spUpdateOperation_Product
  @jsonInput NVARCHAR(MAX)
AS
BEGIN
  SET XACT_ABORT ON;
  BEGIN TRY
    BEGIN TRANSACTION;

    -- stores temporarily
    DECLARE @UpdatedProducts TABLE
    (
      Product_id INT,
      Name VARCHAR(100),
      Description VARCHAR(300),
      Price DECIMAL(6, 2),
      RemainingInStock INT);

    -- Updating Product table using the provided JSON data
    UPDATE Product
    SET
      Name = JSON_VALUE(@jsonInput, '$.Name'),
      Description = JSON_VALUE(@jsonInput, '$.Description'),
      Price = JSON_VALUE(@jsonInput, '$.Price'),
      RemainingInStock = JSON_VALUE(@jsonInput, '$.RemainingInStock')
    OUTPUT
      INSERTED.Product_id,
      INSERTED.Name,
      INSERTED.Description,
      INSERTED.Price,
      INSERTED.RemainingInStock
    INTO @UpdatedProducts
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
  "Product_id": 12,
  "Name": "New Updated DEMO Product ",
  "Description": "Some new Description",
  "Price": 37.00,
  "RemainingInStock": 10
}';

EXEC spUpdateOperation_Product @jsonInput = @jsonData;
