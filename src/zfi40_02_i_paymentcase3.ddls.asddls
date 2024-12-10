@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Get data case 3 for Payment'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations:true

define root view entity ZFI40_02_I_paymentcase3
  as select from I_JournalEntryItem as Item
association [1] to I_JournalEntry             as Header         on  Item.CompanyCode        = Header.CompanyCode
                                                                and Item.FiscalYear         = Header.FiscalYear
                                                                and Item.AccountingDocument = Header.AccountingDocument

association [1] to ZFI40_02_I_paymentdocument as PayDoc         on  Item.CompanyCode            = PayDoc.CompanyCode
                                                                and Item.FiscalYear             = PayDoc.FiscalYear
                                                                and Item.SourceLedger           = PayDoc.SourceLedger
                                                                and Item.AccountingDocument     = PayDoc.AccountingDocument
                                                                and Item.Ledger                 = PayDoc.Ledger
                                                                and PayDoc.FinancialAccountType = 'K'

association [1] to zfi40_02_I_PayBank         as PayDocBank     on  Item.CompanyCode                = PayDocBank.CompanyCode
                                                                and Item.FiscalYear                 = PayDocBank.FiscalYear
                                                                and Item.SourceLedger               = PayDocBank.SourceLedger
                                                                and Item.AccountingDocument         = PayDocBank.AccountingDocument
                                                                and Item.Ledger                     = PayDocBank.Ledger
                                                                and PayDocBank.FinancialAccountType = 'S'

association [1] to ZFI40_02_I_JournalEntry    as _ZJournalEntry on  _ZJournalEntry.CompanyCode        = Item.CompanyCode
                                                                and _ZJournalEntry.FiscalYear         = Item.FiscalYear
                                                                and _ZJournalEntry.AccountingDocument = Item.AccountingDocument

association [1] to ZFI40_02_I_supplier2       as _supplier2     on  _supplier2.Supplier = Item.Supplier
{

  key Item.SourceLedger,
  key Item.CompanyCode,
  key Item.FiscalYear,
  key Item.AccountingDocument,
      Item.LedgerGLLineItem,
      Item.Ledger,
      Item.PostingDate,
      Item.Supplier,
      Item.DocumentDate,
      Item.AccountingDocumentType,

      Item.CompanyCodeCurrency,
      //@Aggregation.default: #SUM
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      Item.AmountInCompanyCodeCurrency,
      
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      Item.AmountInCompanyCodeCurrency as ClearedAmountCodCur,

      Item.TransactionCurrency,
      //@Aggregation.default: #SUM
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      Item.AmountInTransactionCurrency,
      
      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      Item.AmountInTransactionCurrency as ClearedAmountTranCur,


      Item.InvoiceReference,
      Item.InvoiceReferenceFiscalYear,
      Item.IsReversed,
      Item.IsReversal,
      Item.ClearingJournalEntry,
      Item.FinancialAccountType,
      Item.InvoiceItemReference,
      Item.FollowOnDocumentType,

      Header.DocumentReferenceID,
      _Supplier.SupplierName           as SupplierFullName,
      _Supplier.BPAddrStreetName,
      _Supplier.BPAddrCityName,
      _supplier2.SupplierAddress       as SupplierAddress,
      _Supplier.PhoneNumber1,
      _Supplier.PhoneNumber2,
      _Supplier.FaxNumber,
      case
      when _Supplier.PhoneNumber1 is not initial and _Supplier.PhoneNumber2 is not initial
      then concat_with_space(concat(_Supplier.PhoneNumber1,','),_Supplier.PhoneNumber2, 1)
      when _Supplier.PhoneNumber1 is not initial and _Supplier.PhoneNumber2 is initial
      then _Supplier.PhoneNumber1
      when _Supplier.PhoneNumber1 is initial and _Supplier.PhoneNumber2 is not initial
      then _Supplier.PhoneNumber2
      else
        ''
      end                              as SupplierContact,

      case
      when Item.ClearingJournalEntry = '' and Item.FinancialAccountType = 'K'
      then _ZJournalEntry.AccountingDocumentHeaderText
      end                              as ClearedDocumentNumber,

      case
      when Item.ClearingJournalEntry = '' and Item.FinancialAccountType = 'K'
      then ''
      end                              as ClearedDocumentDate,

      case
      when Item.ClearingJournalEntry = '' and Item.FinancialAccountType = 'K'
      then ''
      end                              as ClearedDocumentType,

      case
      when Item.ClearingJournalEntry = '' and Item.FinancialAccountType = 'K'
      then _ZJournalEntry.AccountingDocumentHeaderText
      end                              as ClearedDocumentRef,

      case
      when Item.ClearingJournalEntry = '' and Item.FinancialAccountType = 'K'
      then Item.AccountingDocument
      end                              as PaymentDocument,

      PayDoc.DocumentDate              as PayDocDate,
      PayDoc.AccountingDocumentType    as PayDocType,
      PayDoc.DocumentReferenceID       as PayDocref,
      cast('' as abap.char(40) )       as PayComCodeCurr,
      cast('' as abap.char(40) )       as PayAmountComCodeCurr,

      PayDoc.AccountingDocCreatedByUser,
      PayDoc.UserDescription,
      PayDocBank.HouseBank             as HouseBank,
      PayDocBank.HouseBankAccount      as HouseBankAccount,
      PayDocBank.GLAccount             as GLAccount,
      PayDocBank.GLAccountLongName     as GLAccountLongName
}
where
  //  (     Item.FollowOnDocumentType   <> 'Z'
  //  and  Item.ClearingJournalEntry   =  '' )
  //
  //  and(
  //       Item.AccountingDocumentType =  'KZ'
  //    or Item.AccountingDocumentType =  'KB'
  //  )
  //  and  Item.FinancialAccountType   =  'K'
  //  and  Item.SpecialGLCode          =  'A'

(      Item.AccountingDocumentType =  'KZ'
  or  Item.AccountingDocumentType =  'KB'
  and

      Item.FollowOnDocumentType   <> 'Z'
  and Item.ClearingJournalEntry   =  ''

  and Item.FinancialAccountType   =  'K'
  and Item.SpecialGLCode          =  'A' )
  
