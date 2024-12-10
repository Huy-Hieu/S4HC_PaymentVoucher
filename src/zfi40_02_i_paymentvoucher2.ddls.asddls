@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root view for payment voucher'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations:true

define root view entity ZFI40_02_I_PAYMENTVOUCHER2
  as select from ZFI40_02_I_PaymentVoucher as Item

{
    key SourceLedger,
    key CompanyCode,
    key FiscalYear,
    key AccountingDocument,
    key LedgerGLLineItem,
    Ledger,
    PostingDate,
    Supplier,
    DocumentDate,
    AccountingDocumentType,
    CompanyCodeCurrency,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
    AmountInCompanyCodeCurrency,
    @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
    ClearedAmountCodCur,
    TransactionCurrency,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    AmountInTransactionCurrency,
    @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
    ClearedAmountTranCur,
    InvoiceReference,
    InvoiceReferenceFiscalYear,
    IsReversed,
    IsReversal,
    ClearingJournalEntry,
    FinancialAccountType,
    InvoiceItemReference,
    FollowOnDocumentType,
    DocumentReferenceID,
    SupplierFullName,
    BPAddrStreetName,
    BPAddrCityName,
    SupplierAddress,
    PhoneNumber1,
    PhoneNumber2,
    FaxNumber,
    SupplierContact,
    ClearedDocumentNumber,
    ClearedDocumentDate,
    ClearedDocumentType,
    ClearedDocumentRef,
    PaymentDocument,
    PayDocDate,
    PayDocType,
    PayDocref,
    PayComCodeCurr,
    PayAmountComCodeCurr,
    AccountingDocCreatedByUser,
    UserDescription,
    HouseBank,
    HouseBankAccount,
    GLAccount,
    GLAccountLongName
}
where
  Item.PaymentDocument is not initial
   

