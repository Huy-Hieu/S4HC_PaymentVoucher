@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Get data Bank for Payment'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations:true

define view entity zfi40_02_I_PayBank
  as select distinct from I_JournalEntryItem as Item
  association [0..1] to I_JournalEntry as Header on  Item.CompanyCode        = Header.CompanyCode
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
  key Item.Ledger,
      Item.FinancialAccountType,
      Item.AccountingDocumentType,
      Item.HouseBank,
      Item.HouseBankAccount,
      Item.GLAccount,
      _GLAcctInChartOfAccountsText.GLAccountLongName,
      Header.DocumentReferenceID
}
where
    Item.FinancialAccountType = 'S'
and Item.HouseBank is not initial
and Item.HouseBankAccount is not initial
