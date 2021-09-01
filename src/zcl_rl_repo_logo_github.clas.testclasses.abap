CLASS ltc_rl_repo_logo_github DEFINITION DEFERRED.
CLASS zcl_rl_repo_logo_github DEFINITION LOCAL FRIENDS ltc_rl_repo_logo_github.

CLASS ltc_rl_repo_logo_github DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS FINAL.

  PRIVATE SECTION.
    DATA: mo_cut TYPE REF TO zcl_rl_repo_logo_github.  "class under test

    CLASS-METHODS: class_setup.
    CLASS-METHODS: class_teardown.
    METHODS: setup.
    METHODS: teardown.
    METHODS: get FOR TESTING.
ENDCLASS.       "ltc_Repo_Logo_Github


CLASS ltc_rl_repo_logo_github IMPLEMENTATION.

  METHOD class_setup.

  ENDMETHOD.


  METHOD class_teardown.

  ENDMETHOD.


  METHOD setup.

    DATA lv_token TYPE string.
    DATA ls_repo TYPE zcl_rl_repo_logo_factory=>ty_repo.

    ls_repo-owner = 'octocat'.
    ls_repo-name = 'Hello-World'.
    lv_token = '<YOUR GITHUB TOKEN>'.

    mo_cut ?= zcl_rl_repo_logo_factory=>get_instance( iv_service = 'github'
                                                      is_repo  = ls_repo
                                                      iv_token = lv_token ).
  ENDMETHOD.

  METHOD teardown.

  ENDMETHOD.

  METHOD get.
    DATA li_repo_logo TYPE REF TO zif_rl_repo_logo.
    DATA lv_logo TYPE xstring.
    DATA lv_extension TYPE string.

    li_repo_logo = mo_cut->get(  ).
    lv_logo = li_repo_logo->get( ).
    lv_extension = li_repo_logo->get_extension( ).

    IF lv_logo IS INITIAL.
      cl_aunit_assert=>fail( msg = 'Logo is initial' ).
    ENDIF.

    IF lv_extension IS INITIAL.
      cl_aunit_assert=>fail( msg = 'Extension is initial' ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
