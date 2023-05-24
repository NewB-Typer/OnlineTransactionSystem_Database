---- Stored Procedure for discounted Invoice and other Mentioned Conditions --


CREATE PROCEDURE spUpdateInvoiceWithDiscount
  @Invoice_id INT,
  @Customer_id INT,
  @IssuedDate DATE
AS
BEGIN
  SET XACT_ABORT ON;
  BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @TotalBill DECIMAL(8,2);
    DECLARE @DiscountedTotal DECIMAL(8,2);

    -- Calculating the sum of Stransaction.TotalAmount
    --- To obtain Invoice.TotalBill
    SELECT @TotalBill = SUM(TotalAmount)
    FROM STransaction
    WHERE Customer_id = @Customer_id;

    -- Calculation for Discount value
    IF @TotalBill <= 1000
      SET @DiscountedTotal = @TotalBill * 0.95; -- 5% discount
    ELSE
      SET @DiscountedTotal = @TotalBill * 0.90; -- 10% discount

    UPDATE Invoice
    SET
      Customer_id = @Customer_id,
      TotalBill = @DiscountedTotal,
      IssuedDate = @IssuedDate,
      DiscountedTotal = @DiscountedTotal
    WHERE
      Invoice_id = @Invoice_id;

    COMMIT;
  END TRY
  BEGIN CATCH
    IF @@TRANCOUNT > 0
      ROLLBACK;

    THROW;
  END CATCH;
END
