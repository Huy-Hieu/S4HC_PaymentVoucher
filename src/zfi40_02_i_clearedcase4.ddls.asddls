@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Get data Cleared  case 4 for Payment'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations:true

define view entity zfi40_02_I_ClearedCase4
  as select from I_JournalEntryItem as Item
  association [0..1] to I_JournalEntry  as Header                       on  Item.CompanyCode        = Header.CompanyCode
                                                                        and Item.FiscalYear         = Header.FiscalYear
                                                                        and Item.AccountingDocument = Header.AccountingDocument
  association [0..1] to I_GLAccountText as _GLAcctInChartOfAccountsText on  Item.ChartOfAccounts                  = _GLAcctInChartOfAccountsText.ChartOfAccounts
                                                                        and Item.GLAccount                        = _GLAcctInChartOfAccountsText.GLAccount
                                                                        and _GLAcctInChartOfAccountsText.Language = 'E'

{

  key Item.SourceLedger,
  key Item.CompanyCode,
  key Item.FiscalYear,
  key Item.AccountingDocument,
  key Item.LedgerGLLineItem,
  key Item.Ledger,
      Item.ClearingJournalEntry,
      Item.InvoiceReference,
      Item.FinancialAccountType,
      Item.FollowOnDocumentType,
      Item.DocumentDate,
      Item.AccountingDocumentType,
      Item.HouseBank,
      Item.HouseBankAccount,
      Item.GLAccount,
      
      Item.CompanyCodeCurrency,
      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      Item.AmountInCompanyCodeCurrency,
      
      _GLAcctInChartOfAccountsText.GLAccountLongName,
      Header.DocumentReferenceID
}
where
  //        not(
  //          Item.AccountingDocumentType   =  'KZ'
  //          and Item.FollowOnDocumentType =  ''
  //        )
      Item.AccountingDocumentType <> 'SU'
  and Item.AccountingDocumentType <> 'KB'
  and Item.AccountingDocumentType <> 'KZ'
  and Item.FinancialAccountType   =  'K'
