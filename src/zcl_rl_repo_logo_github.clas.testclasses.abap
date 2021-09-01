CLASS ltc_rl_repo_logo_github DEFINITION DEFERRED.
CLASS zcl_rl_repo_logo_github DEFINITION LOCAL FRIENDS ltc_rl_repo_logo_github.

CLASS ltc_rl_repo_logo_github DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    DATA: mi_cut TYPE REF TO zif_rl_repo_logo_git.

    CLASS-METHODS: class_setup.
    CLASS-METHODS: class_teardown.
    METHODS: setup.
    METHODS: teardown.
    METHODS: get FOR TESTING.
ENDCLASS.


CLASS ltc_rl_repo_logo_github IMPLEMENTATION.

  METHOD class_setup.

  ENDMETHOD.


  METHOD class_teardown.

  ENDMETHOD.


  METHOD setup.

    DATA lv_token TYPE string.
    DATA ls_repo TYPE zcl_rl_repo_logo_factory=>ty_repo.
    DATA lx_e TYPE REF TO zcx_abapgit_exception.
    DATA lv_e_msg TYPE string.

    ls_repo-owner = 'octocat'.
    ls_repo-name = 'Hello-World'.
    lv_token = '<YOUR GITHUB TOKEN>'.

    TRY.
        mi_cut = zcl_rl_repo_logo_factory=>get_instance( iv_service = 'github'
                                                         is_repo  = ls_repo
                                                         iv_token = lv_token ).
      CATCH zcx_abapgit_exception INTO lx_e.
        lv_e_msg = lx_e->get_text( ).
        cl_abap_unit_assert=>fail( msg = lv_e_msg ).
    ENDTRY.

  ENDMETHOD.

  METHOD teardown.

  ENDMETHOD.

  METHOD get.
    DATA li_repo_logo TYPE REF TO zif_rl_repo_logo.
    DATA lv_logo TYPE xstring.
    DATA lv_extension TYPE string.
    DATA lx_e TYPE REF TO zcx_abapgit_exception.
    DATA lv_e_msg TYPE string.

    TRY.
        li_repo_logo = mi_cut->get(  ).
        lv_logo = li_repo_logo->get( ).
        lv_extension = li_repo_logo->get_extension( ).

        IF lv_logo IS INITIAL.
          cl_abap_unit_assert=>fail( msg = 'Logo is initial' ).
        ENDIF.

        IF lv_extension IS INITIAL.
          cl_abap_unit_assert=>fail( msg = 'Extension is initial' ).
        ENDIF.

      CATCH zcx_abapgit_exception INTO lx_e.
        lv_e_msg = lx_e->get_text( ).
        cl_abap_unit_assert=>fail( msg = lv_e_msg ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
