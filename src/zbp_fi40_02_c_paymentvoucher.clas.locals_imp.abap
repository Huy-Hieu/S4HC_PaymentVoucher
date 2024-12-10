CLASS lhc_pv DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR pv RESULT result.

*    METHODS create FOR MODIFY
*      IMPORTING entities FOR CREATE pv.
*
*    METHODS update FOR MODIFY
*      IMPORTING entities FOR UPDATE pv.
*
*    METHODS delete FOR MODIFY
*      IMPORTING keys FOR DELETE pv.

    METHODS read FOR READ
      IMPORTING keys FOR READ pv RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK pv.

    METHODS getpdf FOR READ
      IMPORTING keys FOR FUNCTION pv~getpdf RESULT result.

*    METHODS printPDFV1 FOR MODIFY
*      IMPORTING keys FOR ACTION pv~printPDFV1 RESULT result.

ENDCLASS.

CLASS lhc_pv IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

*  METHOD create.
*  ENDMETHOD.
*
*  METHOD update.
*  ENDMETHOD.
*
*  METHOD delete.
*  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD getpdf.
***Fill data:
    "Structure for payload to ADS BTP'
    TYPES: BEGIN OF ty_post_document_body,
             filename      TYPE string,
             format        TYPE string,
             rawdata       TYPE string,
             jsonfieldname TYPE string,
           END OF ty_post_document_body,
           "Structure for table input
           BEGIN OF ty_input,
             acctdoc(1000) TYPE c,
           END OF ty_input,

           BEGIN OF ty_input2,
             paymentdocument(10) TYPE c,
             fiscalyear          TYPE gjahr,
             sourceledger        TYPE fins_ledger,
           END OF ty_input2.


    DATA: post_document_body TYPE ty_post_document_body,
          lt_accdoc          TYPE  TABLE OF ty_input,
          lt_dt              TYPE  TABLE OF ty_input2,
          ls_dt              TYPE ty_input2.

    TYPES: BEGIN OF ty_data,
             filename    TYPE string,
             filecontent TYPE string,
             tracestring TYPE string,
           END OF ty_data.
    DATA: ls_data TYPE ty_data .

    CONSTANTS:
      content_type TYPE string VALUE 'Content-type',
      txt_content  TYPE string VALUE 'plain/txt',
      json_content TYPE string VALUE 'application/json; charset=UTF-8',
      lv_template  TYPE string VALUE 'FI_4002_F/ZAF_FI_4002_F'.

    DEFINE concat_value.
      IF &1 IS NOT INITIAL.
        IF &2 IS NOT INITIAL.
          &2 = &2 && ` ` && &1.
        ELSE.
          &2 = &1.
        ENDIF.
      ENDIF.
    END-OF-DEFINITION.

    DEFINE concat_value2.
      IF &1 IS NOT INITIAL.
        IF &2 IS NOT INITIAL.
          &2 = &2 && `, ` && &1.
        ELSE.
          &2 = &1.
        ENDIF.
      ENDIF.
    END-OF-DEFINITION.

    DATA: lv_json_payload TYPE string,
          lv_setbody      TYPE string,
          lv_xml_raw      TYPE string.
    DATA: ls_result LIKE LINE OF result .
    DATA: lv_acc                   TYPE zfi40_02_c_paymentvoucher2-accountingdocument,
          lv_year                  TYPE zfi40_02_c_paymentvoucher2-fiscalyear,
          lv_company               TYPE zfi40_02_c_paymentvoucher2-companycode,
          lv_sourceledger          TYPE zfi40_02_c_paymentvoucher2-sourceledger,
          lv_sup                   TYPE zfi40_02_c_paymentvoucher2-supplier,
          lv_supname               TYPE zfi40_02_c_paymentvoucher2-supplierfullname,
          lv_supaddress            TYPE zfi40_02_c_paymentvoucher2-supplieraddress,
          lv_suppliercontact       TYPE zfi40_02_c_paymentvoucher2-suppliercontact,
          lv_paymentdocument       TYPE zfi40_02_c_paymentvoucher2-paymentdocument,
          lv_documentreferenceid   TYPE zfi40_02_c_paymentvoucher2-documentreferenceid,
          lv_cleareddocumentnumber TYPE zfi40_02_c_paymentvoucher2-cleareddocumentnumber,
          lv_documentdate          TYPE zfi40_02_c_paymentvoucher2-documentdate,
          lv_phonenumber1          TYPE zfi40_02_c_paymentvoucher2-phonenumber1,
          lv_phonenumber2          TYPE zfi40_02_c_paymentvoucher2-phonenumber2,
          lv_supfaxnumber          TYPE zfi40_02_c_paymentvoucher2-faxnumber,
          lv_currency              TYPE string,
          lv_supphone              TYPE string,
          lv_supno                 TYPE string,
          lv_supphone2             TYPE string.

    DATA: lv_item        TYPE string,
          lv_total       TYPE string,
          lv_amount_c    TYPE string,
          lv_totalamount TYPE string.

    DATA : w_date        TYPE zfi40_02_c_paymentvoucher2-documentdate,
           w_date1(10),
           w_docdate(10).
    CONSTANTS : c(1) VALUE '-'.

************ GET MASTER DATA LF COMPANY NAME FOR HEADER *************************************************************
    DATA: lv_companyname TYPE string,
          lv_address     TYPE string,
          lv_address2    TYPE string,
          lv_sstno       TYPE string,
          lv_regist      TYPE string,
          lv_tel         TYPE string,
          lv_fax         TYPE string,
          lv_email       TYPE string,
          lv_web         TYPE string.

    lv_company = keys[ 1 ]-%param-companycode.
    SELECT
     companyfullname,
     companycoderegistrationnumber,
     companycoderegistrationnumber2,
     streetname,
     streetsuffixname1,
     streetsuffixname2,
     postalcode,
     cityname,
     countryname,
     internationalphonenumber,
     internationalfaxnumber,
     emailaddress,
     uri
    FROM zcompanycodeinfo
    WHERE companycode = @lv_company
    INTO TABLE @DATA(lt_info).
    DELETE ADJACENT DUPLICATES FROM lt_info COMPARING ALL FIELDS.
    LOOP AT lt_info INTO DATA(ls_comp).
      IF  lv_fax IS INITIAL.
        lv_fax   = ls_comp-internationalfaxnumber.
      ELSE.
        lv_fax   = lv_fax && `, ` && ls_comp-internationalfaxnumber.
      ENDIF.
    ENDLOOP.

    SELECT SINGLE * FROM zcompanycodeinfo WHERE companycode = @lv_company INTO @DATA(ls_info).
    lv_companyname = ls_info-companyfullname.
    TRANSLATE lv_companyname TO UPPER CASE .
    lv_regist = `Registration No. ` && ls_info-companycoderegistrationnumber && ` ` && ls_info-companycoderegistrationnumber2.
    lv_address = ls_info-streetname && ` ` && ls_info-streetsuffixname1 && ` ` && ls_info-streetsuffixname2.
    lv_address2 = ls_info-postalcode && ` ` && ls_info-cityname && ` ` && ls_info-countryname.
    IF  lv_company = '1200'.
      lv_tel   = ls_info-internationalphonenumber && ` (30 Lines)`.
    ELSE.
      lv_tel   = ls_info-internationalphonenumber.
      lv_sstno = `SST No.: ` && ls_info-sstnumber.
    ENDIF.
    lv_email = ls_info-emailaddress.
    lv_web   = ls_info-uri.
*******************************************************************************************************
    TRY.
***Process data:
        "Get data table from param frontend
        SPLIT keys[ 1 ]-%param-accountingdocument AT '|' INTO TABLE lt_accdoc.
        " Remove duplicate data
        DELETE ADJACENT DUPLICATES FROM lt_accdoc.
        IF lt_accdoc IS NOT INITIAL.
          LOOP AT lt_accdoc INTO DATA(ls_accdoc).
            ls_dt-paymentdocument = ls_accdoc-acctdoc+0(10).
            ls_dt-sourceledger = ls_accdoc-acctdoc+14(2).
            ls_dt-fiscalyear = ls_accdoc-acctdoc+10(4).

            APPEND ls_dt TO lt_dt.
            CLEAR : ls_dt.
          ENDLOOP.
        ENDIF.

        "Get data from CDS paymentvoucher
        SELECT
            payment~paymentdocument,
            payment~paydocref,
            payment~cleareddocumentdate,
            payment~accountingdocument,
            payment~sourceledger,
            payment~fiscalyear,
            payment~phonenumber1,
            payment~phonenumber2,
            payment~faxnumber,
            payment~supplierfullname,
            payment~supplieraddress,
            payment~invoicereference,
            payment~amountincompanycodecurrency,
            payment~amountintransactioncurrency,
            payment~transactioncurrency,
            payment~documentdate,
            payment~cleareddocumentnumber,
            payment~followondocumenttype,
            payment~supplier,
            cleareddocumentref,
            clearingjournalentry,
            clearedamountcodcur,
            companycodecurrency
        FROM zfi40_02_c_paymentvoucher2 AS payment
        JOIN @lt_dt AS data ##ITAB_DB_SELECT  ##ITAB_KEY_IN_SELECT
          ON data~paymentdocument    = payment~paymentdocument
         AND data~sourceledger       = payment~sourceledger
         AND data~fiscalyear         = payment~fiscalyear
         AND payment~companycode     = @lv_company
        INTO TABLE @DATA(lt_payment).
        SORT lt_payment BY paymentdocument.
        DELETE ADJACENT DUPLICATES FROM lt_payment COMPARING ALL FIELDS .
        DATA(lt_header) = lt_payment .
        DATA(lt_checkcase) = lt_payment .
        SORT lt_header BY paymentdocument.

        "check case 1&4 or 2&3
        SORT lt_checkcase BY paymentdocument clearingjournalentry.
        DELETE ADJACENT DUPLICATES FROM lt_checkcase COMPARING paymentdocument clearingjournalentry .
        SORT lt_checkcase BY paymentdocument .

        SELECT DISTINCT
          data~paymentdocument,
          it~clearingjournalentry,
          it~sourceledger,
          it~fiscalyear
        FROM i_journalentryitem AS it
        JOIN @lt_dt AS data ##ITAB_DB_SELECT  ##ITAB_KEY_IN_SELECT
         ON data~paymentdocument = it~accountingdocument
        AND companycode  = @lv_company
        AND data~sourceledger       = it~sourceledger
        AND data~fiscalyear         = it~fiscalyear
        AND it~clearingjournalentry IS NOT INITIAL
        INTO TABLE @DATA(lt_case14).

        SELECT
            data~paymentdocument,
            it~invoicereference,
            it~clearingjournalentry,
            SUM( amountincompanycodecurrency ) AS amount
        FROM i_journalentryitem AS it
        JOIN @lt_case14 AS data ##ITAB_DB_SELECT  ##ITAB_KEY_IN_SELECT
          ON data~clearingjournalentry = it~clearingjournalentry
         AND companycode  = @lv_company
         AND data~sourceledger       = it~sourceledger
         AND data~fiscalyear         = it~fiscalyear
         AND it~followondocumenttype = 'Z'
         AND it~accountingdocumenttype IN ( 'KZ', 'KB' )
        GROUP BY data~paymentdocument, it~clearingjournalentry, invoicereference
        INTO TABLE @DATA(lt_amount).
        SORT lt_amount BY paymentdocument clearingjournalentry invoicereference .

        SELECT
            data~paymentdocument,
            it~clearingjournalentry,
            it~accountingdocument,
            documentreferenceid,
            amountincompanycodecurrency,
            companycodecurrency,
            documentdate
        FROM zfi40_02_i_clearedcase4 AS it
        JOIN @lt_case14 AS data ##ITAB_DB_SELECT  ##ITAB_KEY_IN_SELECT
          ON data~clearingjournalentry = it~clearingjournalentry
         AND companycode  = @lv_company
         AND data~sourceledger       = it~sourceledger
         AND data~fiscalyear         = it~fiscalyear
        INTO TABLE @DATA(lt_case1).
**********************************************************************
DATA(lv_lines) = lines(  Lt_dt ) .
data : lv_break  TYPE string.

        LOOP AT lt_dt INTO ls_dt.
          DATA(lv_index) = sy-tabix.
          IF lv_index NE lv_lines.
            lv_break = 'X'.  "New Payment = Break Page
          ENDIF.
**************PROCESS FOR HEADER FORM***
          READ TABLE lt_header INTO DATA(ls_offrc) BINARY SEARCH
                  WITH KEY paymentdocument = ls_dt-paymentdocument.
          IF sy-subrc = 0.
            SELECT SINGLE
                paymentdocument,
                clearingjournalentry,
                paydocdate
            FROM zfi40_02_c_paymentvoucher2
            WHERE paymentdocument = @ls_offrc-paymentdocument
              AND companycode  = @lv_company
              AND sourceledger = @ls_offrc-sourceledger
              AND fiscalyear   = @ls_offrc-fiscalyear
              AND financialaccounttype = 'K'
            INTO  @DATA(ls_date).
            lv_documentdate = ls_date-paydocdate.
            "format date in header
            w_date = lv_documentdate.
            CONCATENATE w_date+6(2) w_date+4(2) w_date+0(4) INTO w_docdate SEPARATED BY c.
            CLEAR: w_date, w_date1.

            "Get Receipt No + Supplier No + documentreference
            lv_paymentdocument = ls_offrc-paymentdocument.
            lv_documentreferenceid = ls_offrc-paydocref.
            lv_sup = ls_offrc-supplier.
          ENDIF.

          IF lv_sup IS NOT INITIAL.
            SELECT SINGLE
                sl~supplier,
                sl~addressid,
                sl~suppliername,
                sl~bpaddrstreetname,
                sl~phonenumber1,
                sl~phonenumber2,
                sl~faxnumber,
                sl~postalcode,
                sl~cityname,
                rt~regionname,
                ct~countryname,
                adr~streetname,
                adr~streetsuffixname1,
                adr~streetsuffixname2
            FROM i_supplier AS sl
            LEFT JOIN i_countrytext AS ct ON ct~country  = sl~country
                                         AND ct~language = 'E'
            LEFT JOIN i_regiontext AS rt ON rt~country  = sl~country
                                        AND rt~region   = sl~region
                                        AND rt~language = 'E'
            LEFT JOIN i_address_2 WITH PRIVILEGED ACCESS AS adr ON adr~addressid = sl~addressid
            WHERE sl~supplier = @lv_sup
            INTO @DATA(ls_sup).
            IF sy-subrc = 0.
              SHIFT ls_sup-supplier LEFT DELETING LEADING '0' .
              lv_supno = `PAID TO:` && ` ` && ls_sup-supplier .
              lv_supname = ls_sup-suppliername.
              DATA(lv_bpaddr) = ls_sup-streetname && ` ` && ls_sup-streetsuffixname1 && ` ` && ls_sup-streetsuffixname2.
              TRANSLATE lv_bpaddr TO UPPER CASE .
              concat_value  ls_sup-postalcode  lv_supaddress.
              concat_value  ls_sup-cityname    lv_supaddress.
              concat_value  ls_sup-regionname  lv_supaddress.
              concat_value2 ls_sup-countryname lv_supaddress.
              TRANSLATE lv_supaddress TO UPPER CASE .
              lv_supphone = ls_sup-phonenumber1 .
              IF ls_sup-phonenumber2 IS NOT INITIAL.
                lv_supphone = ls_sup-phonenumber1 && `, ` && ls_sup-phonenumber2.
              ENDIF.
              lv_supfaxnumber   = ls_sup-faxnumber.
            ENDIF.
          ENDIF.
          REPLACE `&` IN lv_supname WITH `&amp;`.
          REPLACE `&` IN lv_supaddress WITH `&amp;`.
          REPLACE `&` IN lv_bpaddr WITH `&amp;`.

********************PROCESS FOR ITEM FORM*******************************************************************
          ""Check data case 1&4 or 2&3
          LOOP AT lt_checkcase INTO DATA(ls_check) WHERE paymentdocument = ls_dt-paymentdocument.
            IF ls_check-clearingjournalentry IS NOT INITIAL .

              "Loop table input and generate data for form template
              LOOP AT lt_case1 INTO DATA(ls_case1) WHERE paymentdocument = ls_dt-paymentdocument.

                READ TABLE lt_amount INTO DATA(ls_amount) BINARY SEARCH
                    WITH KEY  paymentdocument      = ls_case1-paymentdocument
                              clearingjournalentry = ls_case1-clearingjournalentry
                              invoicereference     = ls_case1-accountingdocument  .
                IF sy-subrc = 0.
                  ls_case1-amountincompanycodecurrency += ls_amount-amount.
                ENDIF.

                IF ls_case1-amountincompanycodecurrency IS NOT INITIAL.
                  ls_case1-amountincompanycodecurrency *= -1 .
                  lv_amount_c = ls_case1-amountincompanycodecurrency .
                ENDIF.
                CONDENSE lv_amount_c .
                IF lv_amount_c < -1.
                  REPLACE `-` IN lv_amount_c WITH ``.
                  CONCATENATE `-` lv_amount_c  INTO lv_amount_c .
                ENDIF.

                "Format Date
                w_date = ls_case1-documentdate.
                CONCATENATE w_date+6(2) w_date+4(2) w_date+0(4) INTO w_date1 SEPARATED BY c.

                IF lv_item IS INITIAL.
                  CONCATENATE '<ZST_ITEM><Desc1>' w_date1 '</Desc1><Desc2>' ls_case1-documentreferenceid '</Desc2><Amount>' lv_amount_c '</Amount></ZST_ITEM>'
                               INTO lv_item .
                ELSE.
                  CONCATENATE lv_item '<ZST_ITEM><Desc1>' w_date1 '</Desc1><Desc2>' ls_case1-documentreferenceid '</Desc2><Amount>' lv_amount_c'</Amount></ZST_ITEM>'
                               INTO lv_item .
                ENDIF.

                ""Total amount
                lv_totalamount += ls_case1-amountincompanycodecurrency.
                lv_currency   = ls_case1-companycodecurrency.
              ENDLOOP.

            ELSE.
              "Loop table input and generate data for form template
              LOOP AT lt_payment INTO DATA(ls_item) WHERE paymentdocument = ls_dt-paymentdocument AND clearingjournalentry IS INITIAL.
                IF ls_item-clearedamountcodcur IS NOT INITIAL.
                  IF ls_item-followondocumenttype = 'Z' .
                    ls_item-clearedamountcodcur *= -1 .
                  ENDIF.
                  lv_amount_c = ls_item-clearedamountcodcur .
                ENDIF.
                CONDENSE lv_amount_c .
                IF lv_amount_c < -1.
                  REPLACE `-` IN lv_amount_c WITH ``.
                  CONCATENATE `-` lv_amount_c  INTO lv_amount_c .
                ENDIF.

                "Format Date
                w_date = ls_item-cleareddocumentdate.
                CONCATENATE w_date+6(2) w_date+4(2) w_date+0(4) INTO w_date1 SEPARATED BY c.

                IF lv_item IS INITIAL.
                  CONCATENATE '<ZST_ITEM><Desc1>' w_date1 '</Desc1><Desc2>' ls_item-cleareddocumentref '</Desc2><Amount>' lv_amount_c '</Amount></ZST_ITEM>'
                               INTO lv_item .
                ELSE.
                  CONCATENATE lv_item '<ZST_ITEM><Desc1>' w_date1 '</Desc1><Desc2>' ls_item-cleareddocumentref '</Desc2><Amount>' lv_amount_c'</Amount></ZST_ITEM>'
                               INTO lv_item .
                ENDIF.

                ""Total amount
                lv_totalamount += ls_item-clearedamountcodcur.
                lv_currency     = ls_item-companycodecurrency.
              ENDLOOP.
            ENDIF.
*********Process total amount:
            CONDENSE lv_totalamount .
            IF lv_totalamount IS NOT INITIAL.
              CONCATENATE lv_total '<ZST_ITEMS_TOTAL><Desc1>' lv_totalamount '</Desc1><Desc2>'  '</Desc2><Amount>' lv_totalamount '</Amount></ZST_ITEMS_TOTAL>'
              INTO lv_total .
            ENDIF.
          ENDLOOP.

********************APPEND VALUE*******************************************************************
          "Append value to struct XML
          IF lv_xml_raw IS INITIAL.
            CONCATENATE  '<ZST_LIST_PAYMENT>'
                         '<CompanyName>' lv_companyname '</CompanyName>'
                         '<ADDRESS>' lv_address '</ADDRESS>'
                         '<ADDRESS2>' lv_address2 '</ADDRESS2>'
                         '<STT_NO>' lv_sstno '</STT_NO>'
                         '<TEL>' lv_tel '</TEL>'
                         '<FAX>' lv_fax '</FAX>'
                         '<EMAIL>' lv_email '</EMAIL>'
                         '<WEBSITE>' lv_web '</WEBSITE>'
                         '<TITLE>' lv_currency '</TITLE>'
                         '<NAME>' lv_regist '</NAME>'
                         '<PARA01>' lv_supname '</PARA01>'
                         '<PARA02>' lv_bpaddr '</PARA02>'
                         '<PARA03>' lv_supphone '</PARA03>'
                         '<PARA04>' lv_supno '</PARA04>'
                         '<PARA05>' lv_paymentdocument '</PARA05>'
                         '<PARA06>' w_docdate '</PARA06>'
                         '<PARA07>' lv_documentreferenceid '</PARA07>'
                         '<PARA08>' lv_totalamount '</PARA08>'
                         '<PARA09>' lv_supfaxnumber '</PARA09>'
                         '<PARA10>' lv_supaddress '</PARA10>'
                         '<Breakpage>' lv_break '</Breakpage>'
                         '<_ITEMS>' lv_item '</_ITEMS>'
                         '<_ITEMS_TOTAL>' lv_total '</_ITEMS_TOTAL>'
                         '</ZST_LIST_PAYMENT>'
            INTO lv_xml_raw.
          ELSE.
            CONCATENATE lv_xml_raw
                         '<ZST_LIST_PAYMENT>'
                         '<CompanyName>' lv_companyname '</CompanyName>'
                         '<ADDRESS>' lv_address '</ADDRESS>'
                         '<ADDRESS2>' lv_address2 '</ADDRESS2>'
                         '<STT_NO>' lv_sstno '</STT_NO>'
                         '<TEL>' lv_tel '</TEL>'
                         '<FAX>' lv_fax '</FAX>'
                         '<EMAIL>' lv_email '</EMAIL>'
                         '<WEBSITE>' lv_web '</WEBSITE>'
                         '<TITLE>' lv_currency '</TITLE>'
                         '<NAME>' lv_regist '</NAME>'
                         '<PARA01>' lv_supname '</PARA01>'
                         '<PARA02>' lv_bpaddr '</PARA02>'
                         '<PARA03>' lv_supphone '</PARA03>'
                         '<PARA04>' lv_supno '</PARA04>'
                         '<PARA05>' lv_paymentdocument '</PARA05>'
                         '<PARA06>' w_docdate '</PARA06>'
                         '<PARA07>' lv_documentreferenceid '</PARA07>'
                         '<PARA08>' lv_totalamount '</PARA08>'
                         '<PARA09>' lv_supfaxnumber '</PARA09>'
                         '<PARA10>' lv_supaddress '</PARA10>'
                         '<Breakpage>' lv_break '</Breakpage>'
                         '<_ITEMS>' lv_item '</_ITEMS>'
                         '<_ITEMS_TOTAL>' lv_total '</_ITEMS_TOTAL>'
                         '</ZST_LIST_PAYMENT>'
            INTO lv_xml_raw.
          ENDIF.
          "clear data:
          CLEAR: lv_supname, lv_bpaddr, lv_supphone, lv_supno, lv_paymentdocument, w_docdate, lv_documentreferenceid,
                 lv_totalamount, lv_supfaxnumber, lv_supaddress, lv_item, lv_total, lv_break.
        ENDLOOP.
        "Concat value finish data:
        CONCATENATE
         '<?xml version="1.0" encoding="UTF-8"?>'
                    '<Form><GT_DATA_AF>' lv_xml_raw
                    '</GT_DATA_AF></Form>' INTO  lv_xml_raw .
********************************************************************** XML
        " Create HTTP client
        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                 comm_scenario  = 'ZFI40_02_PAYMENT_SCENARIO'
                                 comm_system_id = 'ADS_REST_API'
                                 service_id     = 'ZFI40_02_OB_PAYMENT_VOUCHER_REST'
                               ).
        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination ).
        DATA(lo_request) = lo_http_client->get_http_request( ).

        DATA(lv_xml) = cl_web_http_utility=>encode_base64( lv_xml_raw ).

        CONCATENATE '{ "xdpTemplate": "' lv_template '", "xmlData": "' lv_xml '", "formType": "print", "formLocale": "en_US","taggedPdf": 1,  "embedFont": 0,"changeNotAllowed": false,"printNotAllowed": false }' INTO lv_json_payload .

        lo_request->set_text( lv_json_payload  ).

        "Set content format = json
        lo_request->set_header_field( i_name = content_type i_value = json_content ).

        "Request client: => Post
        DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>post ).

        "Status response
        DATA(lv_status) = lo_response->get_status( ).

        "Data return
        lv_json_payload = lo_response->get_text( ).

        /ui2/cl_json=>deserialize( EXPORTING json  = lv_json_payload
                                    CHANGING  data = ls_data ).

        IF  ls_data-filecontent IS NOT INITIAL.
          ls_result-%cid = keys[ 1 ]-%cid .
          ls_result-%param-pdfdata = ls_data-filecontent .
          APPEND ls_result TO result .
        ENDIF.

      CATCH cx_root INTO DATA(lx_exception).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zfi40_02_c_paymentvoucher DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zfi40_02_c_paymentvoucher IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.



ENDCLASS.
