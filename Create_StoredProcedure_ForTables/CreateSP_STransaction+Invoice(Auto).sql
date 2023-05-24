--- This is CREATE(INSERT) operation for STransaction Table as well for Invoice Table
--- This query automatically inserts data into Invoice table obtained from STransaction table


CREATE PROCEDURE spCreateOperation_STransaction
  @jsonData NVARCHAR(MAX)
  AS
BEGIN
  SET XACT_ABORT ON;
  BEGIN TRY
    BEGIN TRANSACTION;
    DECLARE 
      @Transaction_id INT,
      @Customer_id INT,
      @Product_id INT,
      @Quantity INT,
      @UnitPrice DECIMAL(6, 2),
      @TotalAmount DECIMAL(8, 2),
      @Invoice_id INT,
	  @IssuedDate DATE;

    SELECT
      @Transaction_id = JSON_VALUE(@jsonData, '$.Transaction_id'),
      @Customer_id = JSON_VALUE(@jsonData, '$.Customer_id'),
      @Product_id = JSON_VALUE(@jsonData, '$.Product_id'),
      @Quantity = JSON_VALUE(@jsonData, '$.Quantity'),
	  @IssuedDate = JSON_VALUE(@jsonData, '$.IssuedDate');

    -- Product.Price is same as the STransaction.UnitPrice so
    SELECT @UnitPrice = Price FROM Product WHERE Product_id = @Product_id;

    -- Calculating TotalAmount
    SET @TotalAmount = @Quantity * @UnitPrice;

    -- If invoice_id is assigned already
    SELECT @Invoice_id = Invoice_id FROM Invoice WHERE Customer_id = @Customer_id;

    -- Assigning a new Invoice_id if not already assigned
    IF @Invoice_id IS NULL
    BEGIN
      INSERT INTO Invoice (Customer_id, TotalBill, IssuedDate)
      VALUES (@Customer_id, 0, @IssuedDate);

      SET @Invoice_id = SCOPE_IDENTITY(); 
    END

  
    INSERT INTO STransaction (Transaction_id, Customer_id, Product_id, Quantity, UnitPrice, TotalAmount, Invoice_id)
    VALUES (@Transaction_id, @Customer_id, @Product_id, @Quantity, @UnitPrice, @TotalAmount, @Invoice_id);

    -- Updating Invoice.TotalBill accordingly
    UPDATE Invoice
    SET TotalBill = TotalBill + @TotalAmount
    WHERE Invoice_id = @Invoice_id;

    COMMIT;
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0
      ROLLBACK;
    THROW;
  END CATCH;
END


-- Execution code
EXEC spCreateOperation_STransaction @jsonData = '{
  "Transaction_id": 410,
  "Customer_id": 101,
  "Product_id":10,
  "Quantity": 3,
  "IssuedDate": "2022-09-08"
}';

