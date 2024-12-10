@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Get address supplier for zfi4002'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations:true

define view entity ZFI40_02_I_supplier
  as select from I_Supplier as Supplier

  association [1] to I_CountryText as _CountryText on  _CountryText.Country  = Supplier.Country 
                                                   and _CountryText.Language = 'E'

  association [1] to I_RegionText  as _RegionText  on  Supplier.Country     = _RegionText.Country
                                                   and Supplier.Region      = _RegionText.Region
                                                   and _RegionText.Language = 'E'

{
    key Supplier.Supplier,
    Supplier.SupplierAccountGroup,
    Supplier.SupplierName,
    Supplier.SupplierFullName,
    
    Supplier.BPAddrStreetName,
    Supplier.PostalCode,
    Supplier.CityName,
    
    _RegionText.RegionName,
    _CountryText.CountryName,
    concat(Supplier.BPAddrStreetName,  '') as a,
    concat_with_space('', Supplier.PostalCode, 1 ) as b,
    concat_with_space('', Supplier.CityName, 1 )  as c,
    concat_with_space('', _RegionText.RegionName, 1 ) as d,
    concat_with_space(',', _CountryText.CountryName, 1 ) as e,
    concat(Supplier.BPAddrStreetName,concat(Supplier.PostalCode,concat(Supplier.CityName,concat(_RegionText.RegionName,_CountryText.CountryName)))) as SP
}
