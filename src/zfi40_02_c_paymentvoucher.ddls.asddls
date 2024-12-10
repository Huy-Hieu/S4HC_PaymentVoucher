//@AbapCatalog.sqlViewName: 'ZFI40_02_C_PV'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Voucher Report'
@Metadata.allowExtensions: true

//@AbapCatalog.dataMaintenance: #DISPLAY_ONLY
//@Analytics.dataCategory: #CUBE
//@Analytics.internalName: #LOCAL
//@ObjectModel.modelingPattern: #ANALYTICAL_CUBE
//@ObjectModel.supportedCapabilities: [ #ANALYTICAL_PROVIDER, #SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE ]

define root view entity ZFI40_02_C_PaymentVoucher

  as select distinct from ZFI40_02_I_PAYMENTVOUCHER2 as Item
{
  key SourceLedger,
  key CompanyCode,
  key FiscalYear,
  key PaymentDocument,

      //    key AccountingDocument,
      //    key LedgerGLLineItem,
      //    key Ledger,
      //PostingDate,
      Supplier,
      //DocumentDate,
      //AccountingDocumentType,
      //CompanyCodeCurrency,
      //AmountInCompanyCodeCurrency,
      //ClearedAmountCodCur,
      // TransactionCurrency,
      //AmountInTransactionCurrency,
      //ClearedAmountTranCur,
      //InvoiceReference,
      //InvoiceReferenceFiscalYear,
      IsReversed,
      IsReversal,
      //ClearingJournalEntry,
      //FinancialAccountType,
      //InvoiceItemReference,
      //FollowOnDocumentType,
      //DocumentReferenceID,
      SupplierFullName,
      SupplierAddress,
      SupplierContact,
      FaxNumber,

      PayDocDate,
      PayDocType,
      PayDocref,
      //PayComCodeCurr,
      //PayAmountComCodeCurr,
      AccountingDocCreatedByUser,
      UserDescription,
      HouseBank,
      HouseBankAccount,
      GLAccount,
      GLAccountLongName
}
where PaymentDocument is not null
  and PayDocType     = 'KZ'
  or PayDocType      = 'KB'
