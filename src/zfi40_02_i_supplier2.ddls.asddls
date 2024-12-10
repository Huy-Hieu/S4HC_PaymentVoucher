@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Get address supplier for zfi4002'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations:true

define view entity ZFI40_02_I_supplier2
  as select from ZFI40_02_I_supplier as Supplier
{
   key Supplier,
   SupplierAccountGroup,
   SupplierName,
   SupplierFullName,
   BPAddrStreetName,
   PostalCode,
   CityName,
   RegionName,
   CountryName,
   a,
   b,
   c,
   d,
   e,
   SP,
   concat(a,concat(b,concat(c,concat(d,e)))) as SupplierAddress
}
