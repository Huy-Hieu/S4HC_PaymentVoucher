@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Get field cds view JournalEntry'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations:true
define root view entity ZFI40_02_I_JournalEntry
  as select from I_JournalEntry as Header
//  association [0..1] to I_JournalEntry as Header on  Item.CompanyCode        = Header.CompanyCode
//                                                 and Item.FiscalYear         = Header.FiscalYear
//                                                 and Item.AccountingDocument = Header.AccountingDocument
{

    key CompanyCode,
    key FiscalYear,
    key AccountingDocument,
    AccountingDocumentHeaderText,
    DocumentReferenceID
}
//  //and Item.AccountingDocument   <> Item.ClearingJournalEntry
//  and Item.FinancialAccountType =  'D'
//  and Item.FollowOnDocumentType = 'Z'
