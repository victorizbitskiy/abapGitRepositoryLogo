CLASS zcl_rl_repo_logo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES zif_rl_repo_logo.

    METHODS constructor
      IMPORTING
        !iv_logo      TYPE xstring
        !iv_extension TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mv_logo TYPE xstring.
    DATA mv_extension TYPE string.

ENDCLASS.



CLASS ZCL_RL_REPO_LOGO IMPLEMENTATION.


  METHOD constructor.

    mv_logo = iv_logo.
    mv_extension = iv_extension.

  ENDMETHOD.


  METHOD zif_rl_repo_logo~get.

    rv_logo = mv_logo.

  ENDMETHOD.


  METHOD zif_rl_repo_logo~get_extension.

    rv_extension = mv_extension.

  ENDMETHOD.
ENDCLASS.
