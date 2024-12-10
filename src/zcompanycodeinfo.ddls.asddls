//@AbapCatalog.sqlViewName: ''
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
//@AccessControl.authorizationCheck: #NOT_REQUIRED
//@EndUserText.label: 'Cds view Get data company code'
//define view zcompanycodeinfo as select from data_source_name
//{
//    
//}

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CompanyCodeInfo'
@Search.searchable: false
@Metadata.allowExtensions: true
@AbapCatalog.dataMaintenance: #DISPLAY_ONLY
//@DataAging.noAgingRestriction: true
@ObjectModel.supportedCapabilities: [ #CDS_MODELING_ASSOCIATION_TARGET, #CDS_MODELING_DATA_SOURCE ]
@ObjectModel.representativeKey: 'CompanyCode'
define view entity zcompanycodeinfo

as select from I_CompanyCode as I_CompanyCode
association[0..*] to I_Address_2 as _I_Address_2 on _I_Address_2.AddressID = I_CompanyCode.AddressID
association[0..*] to I_OrganizationAddress as _I_OrganizationAddress on _I_OrganizationAddress.AddressID = I_CompanyCode.AddressID
association[0..*] to I_AddressPhoneNumber_2 as _I_AddressPhoneNumber_2 on _I_AddressPhoneNumber_2.AddressID = I_CompanyCode.AddressID
association[0..*] to I_AddressFaxNumber_2 as _I_AddressFaxNumber_2 on _I_AddressFaxNumber_2.AddressID = I_CompanyCode.AddressID
association[0..*] to I_AddressEmailAddress_2 as _I_AddressEmailAddress_2 on _I_AddressEmailAddress_2.AddressID = I_CompanyCode.AddressID
association[0..*] to I_AddressMainWebsiteURL as _I_AddressMainWebsiteURL on _I_AddressMainWebsiteURL.AddressID = I_CompanyCode.AddressID
association[0..1] to I_CountryText as _I_CountryText on _I_CountryText.Country = I_CompanyCode.Country
and _I_CountryText.Language = 'E'
association[0..*] to I_AddlCompanyCodeInformation as _I_AddlCompanyCodeInformation on _I_AddlCompanyCodeInformation.CompanyCode = I_CompanyCode.CompanyCode
association[0..1] to I_OrgAddressDefaultRprstn as _I_OrgAddressDefaultRprstn on _I_OrgAddressDefaultRprstn.AddressID = I_CompanyCode.AddressID

{
@EndUserText.label: 'Company Code'
@ObjectModel.foreignKey.association: null
@ObjectModel.text.association: null
@ObjectModel.text.element: [ 'CompanyCodeName' ]
//@Consumption.groupWithElement: null
//@Consumption.valueHelp: null
@Consumption.hidden: false
@Analytics.excludeFromRuntimeExtensibility: false
@Consumption.filter.mandatory: false
@Consumption.filter.multipleSelections: false
@Consumption.filter.selectionType: null
@Aggregation.default: null
key I_CompanyCode.CompanyCode as CompanyCode,

@EndUserText.label: 'Company Name'
@Semantics.text: true
@ObjectModel.foreignKey.association: null
@ObjectModel.text.association: null
@ObjectModel.text.element: null
//@Consumption.groupWithElement: null
//@Consumption.valueHelp: null
@Consumption.hidden: false
@Analytics.excludeFromRuntimeExtensibility: false
@Consumption.filter.mandatory: false
@Consumption.filter.multipleSelections: false
@Consumption.filter.selectionType: null
@Aggregation.default: null
I_CompanyCode.CompanyCodeName as CompanyCodeName,

@EndUserText.label: 'AddressID'
@ObjectModel.foreignKey.association: null
@ObjectModel.text.association: null
@ObjectModel.text.element: null
//@Consumption.groupWithElement: null
//@Consumption.valueHelp: null
@Consumption.hidden: false
@Analytics.excludeFromRuntimeExtensibility: false
@Consumption.filter.mandatory: false
@Consumption.filter.multipleSelections: false
@Consumption.filter.selectionType: null
@Aggregation.default: null
I_CompanyCode.AddressID as AddressID,

@EndUserText.label: 'City'
@ObjectModel.foreignKey.association: null
@ObjectModel.text.association: null
@ObjectModel.text.element: null
//@Consumption.groupWithElement: null
//@Consumption.valueHelp: null
@Consumption.hidden: false
@Analytics.excludeFromRuntimeExtensibility: false
@Consumption.filter.mandatory: false
@Consumption.filter.multipleSelections: false
@Consumption.filter.selectionType: null
@Aggregation.default: null
I_CompanyCode.CityName as CityName,

@EndUserText.label: 'Country/Region Key'
@ObjectModel.foreignKey.association: null
@ObjectModel.text.association: null
@ObjectModel.text.element: null
//@Consumption.groupWithElement: null
//@Consumption.valueHelp: null
@Consumption.hidden: false
@Analytics.excludeFromRuntimeExtensibility: false
@Consumption.filter.mandatory: false
@Consumption.filter.multipleSelections: false
@Consumption.filter.selectionType: null
@Aggregation.default: null
I_CompanyCode.Country as Country,

@EndUserText.label: 'SST Number'
@ObjectModel.foreignKey.association: null
@ObjectModel.text.association: null
@ObjectModel.text.element: null
//@Consumption.groupWithElement: null
//@Consumption.valueHelp: null
@Consumption.hidden: false
@Analytics.excludeFromRuntimeExtensibility: false
@Consumption.filter.mandatory: false
@Consumption.filter.multipleSelections: false
@Consumption.filter.selectionType: null
@Aggregation.default: null
I_CompanyCode.VATRegistration as SSTNumber,

@EndUserText.label: 'Company Full Name'
@ObjectModel.foreignKey.association: null
@ObjectModel.text.association: null
@ObjectModel.text.element: null
//@Consumption.groupWithElement: null
//@Consumption.valueHelp: null
@Consumption.hidden: false
@Analytics.excludeFromRuntimeExtensibility: false
@Consumption.filter.mandatory: false
@Consumption.filter.multipleSelections: false
@Consumption.filter.selectionType: null
@Aggregation.default: null
_I_Address_2.AddresseeFullName as CompanyFullName,

@EndUserText.label: 'Postal Code'
@ObjectModel.foreignKey.association: null
@ObjectModel.text.association: null
@ObjectModel.text.element: null
//@Consumption.groupWithElement: null
//@Consumption.valueHelp: null
@Consumption.hidden: false
@Analytics.excludeFromRuntimeExtensibility: false
@Consumption.filter.mandatory: false
@Consumption.filter.multipleSelections: false
@Consumption.filter.selectionType: null
@Aggregation.default: null
_I_Address_2.PostalCode as PostalCode,

@EndUserText.label: 'Street'
@ObjectModel.foreignKey.association: null
@ObjectModel.text.association: null
@ObjectModel.text.element: null
//@Consumption.groupWithElement: null
//@Consumption.valueHelp: null
@Consumption.hidden: false
@Analytics.excludeFromRuntimeExtensibility: false
@Consumption.filter.mandatory: false
@Consumption.filter.multipleSelections: false
@Consumption.filter.selectionType: null
@Aggregation.default: null
_I_Address_2.StreetName as StreetName,

@EndUserText.label: 'Telephone Number'
@ObjectModel.foreignKey.association: null
@ObjectModel.text.association: null
@ObjectModel.text.element: null
//@Consumption.groupWithElement: null
//@Consumption.valueHelp: null
@Consumption.hidden: false
@Analytics.excludeFromRuntimeExtensibility: false
@Consumption.filter.mandatory: false
@Consumption.filter.multipleSelections: false
@Consumption.filter.selectionType: null
@Aggregation.default: null
_I_AddressPhoneNumber_2.InternationalPhoneNumber as InternationalPhoneNumber,

@EndUserText.label: 'Email Address'
@ObjectModel.foreignKey.association: null
@ObjectModel.text.association: null
@ObjectModel.text.element: null
//@Consumption.groupWithElement: null
//@Consumption.valueHelp: null
@Consumption.hidden: false
@Analytics.excludeFromRuntimeExtensibility: false
@Consumption.filter.mandatory: false
@Consumption.filter.multipleSelections: false
@Consumption.filter.selectionType: null
@Aggregation.default: null
_I_AddressEmailAddress_2.EmailAddress as EmailAddress,

@EndUserText.label: 'Website'
@ObjectModel.foreignKey.association: null
@ObjectModel.text.association: null
@ObjectModel.text.element: null
//@Consumption.groupWithElement: null
//@Consumption.valueHelp: null
@Consumption.hidden: false
@Analytics.excludeFromRuntimeExtensibility: false
@Consumption.filter.mandatory: false
@Consumption.filter.multipleSelections: false
@Consumption.filter.selectionType: null
@Aggregation.default: null
_I_AddressMainWebsiteURL.UniformResourceIdentifier as URI,

@EndUserText.label: 'Street 2'
@ObjectModel.foreignKey.association: null
@ObjectModel.text.association: null
@ObjectModel.text.element: null
//@Consumption.groupWithElement: null
//@Consumption.valueHelp: null
@Consumption.hidden: false
@Analytics.excludeFromRuntimeExtensibility: false
@Consumption.filter.mandatory: false
@Consumption.filter.multipleSelections: false
@Consumption.filter.selectionType: null
@Aggregation.default: null
_I_OrganizationAddress.StreetSuffixName1 as StreetSuffixName1,

@EndUserText.label: 'Street 3'
@ObjectModel.foreignKey.association: null
@ObjectModel.text.association: null
@ObjectModel.text.element: null
//@Consumption.groupWithElement: null
//@Consumption.valueHelp: null
@Consumption.hidden: false
@Analytics.excludeFromRuntimeExtensibility: false
@Consumption.filter.mandatory: false
@Consumption.filter.multipleSelections: false
@Consumption.filter.selectionType: null
@Aggregation.default: null
_I_OrganizationAddress.StreetSuffixName2 as StreetSuffixName2,

@EndUserText.label: 'Country/Region Name'
@Semantics.text: true
@ObjectModel.foreignKey.association: null
@ObjectModel.text.association: null
@ObjectModel.text.element: null
//@Consumption.groupWithElement: null
//@Consumption.valueHelp: null
@Consumption.hidden: false
@Analytics.excludeFromRuntimeExtensibility: false
@Consumption.filter.mandatory: false
@Consumption.filter.multipleSelections: false
@Consumption.filter.selectionType: null
@Aggregation.default: null
_I_CountryText.CountryName as CountryName,

@EndUserText.label: 'Registration number'
@ObjectModel.foreignKey.association: null
@ObjectModel.text.association: null
@ObjectModel.text.element: null
//@Consumption.groupWithElement: null
//@Consumption.valueHelp: null
@Consumption.hidden: false
@Analytics.excludeFromRuntimeExtensibility: false
@Consumption.filter.mandatory: false
@Consumption.filter.multipleSelections: false
@Consumption.filter.selectionType: null
@Aggregation.default: null
_I_AddlCompanyCodeInformation.CompanyCodeParameterValue as CompanyCodeRegistrationNumber,

@EndUserText.label: 'Fax Number'
@ObjectModel.foreignKey.association: null
@ObjectModel.text.association: null
@ObjectModel.text.element: null
//@Consumption.groupWithElement: null
//@Consumption.valueHelp: null
@Consumption.hidden: false
@Analytics.excludeFromRuntimeExtensibility: false
@Consumption.filter.mandatory: false
@Consumption.filter.multipleSelections: false
@Consumption.filter.selectionType: null
@Aggregation.default: null
_I_AddressFaxNumber_2.InternationalFaxNumber as InternationalFaxNumber,

@EndUserText.label: 'Registration number 2'
@ObjectModel.foreignKey.association: null
@ObjectModel.text.association: null
@ObjectModel.text.element: null
//@Consumption.groupWithElement: null
//@Consumption.valueHelp: null
@Consumption.hidden: false
@Analytics.excludeFromRuntimeExtensibility: false
@Consumption.filter.mandatory: false
@Consumption.filter.multipleSelections: false
@Consumption.filter.selectionType: null
@Aggregation.default: null
_I_OrgAddressDefaultRprstn.AddressSearchTerm2 as CompanyCodeRegistrationNumber2
}
