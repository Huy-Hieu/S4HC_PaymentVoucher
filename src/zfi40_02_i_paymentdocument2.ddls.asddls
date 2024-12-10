@AbapCatalog.dataMaintenance: #DISPLAY_ONLY
@Analytics.dataCategory: #CUBE
@Analytics.internalName: #LOCAL
@ObjectModel.modelingPattern: #ANALYTICAL_CUBE
@ObjectModel.supportedCapabilities: [ #ANALYTICAL_PROVIDER, #SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'get field for payment voucher'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations:true

define root view entity ZFI40_02_I_PAYMENTDOCUMENT2
  as select distinct from I_JournalEntryItem as Item
  association [0..1] to I_JournalEntry  as Header                       on  Item.CompanyCode        = Header.CompanyCode
                                                                        and Item.FiscalYear         = Header.FiscalYear
                                                                        and Item.AccountingDocument = Header.AccountingDocument
{

  key Item.SourceLedger,
  key Item.CompanyCode,
  key Item.FiscalYear,
  key Item.AccountingDocument,
  key Item.Ledger,
      Item.FinancialAccountType,
      Item.DocumentDate,
      Item.AccountingDocumentType,
      Item.HouseBank,
      Item.HouseBankAccount,
      Header.DocumentReferenceID,
      Item.AccountingDocCreatedByUser,
      _User.UserDescription
}
where Item.FinancialAccountType = 'K'
