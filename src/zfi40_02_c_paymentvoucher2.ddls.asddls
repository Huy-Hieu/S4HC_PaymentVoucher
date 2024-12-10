//@AbapCatalog.sqlViewName: 'ZFI40_02_C_PV'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Voucher Get data for Form'
@Metadata.allowExtensions: true

//@AbapCatalog.dataMaintenance: #DISPLAY_ONLY
//@Analytics.dataCategory: #CUBE
//@Analytics.internalName: #LOCAL
//@ObjectModel.modelingPattern: #ANALYTICAL_CUBE
//@ObjectModel.supportedCapabilities: [ #ANALYTICAL_PROVIDER, #SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE ]

define root view entity ZFI40_02_C_PAYMENTVOUCHER2 

 as select from ZFI40_02_I_PaymentVoucher
{
    key SourceLedger,
    key CompanyCode,
    key FiscalYear,
    key AccountingDocument,
    key LedgerGLLineItem,
    key Ledger,
    PostingDate,
    Supplier,
    DocumentDate,
    AccountingDocumentType,
    CompanyCodeCurrency,
    AmountInCompanyCodeCurrency,
    ClearedAmountCodCur,
    TransactionCurrency,
    AmountInTransactionCurrency,
    ClearedAmountTranCur,
    InvoiceReference,
    InvoiceReferenceFiscalYear,
    IsReversed,
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
