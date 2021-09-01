CLASS zcl_rl_repo_logo_factory DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_repo,
        owner TYPE string,
        name  TYPE string,
      END OF ty_repo.

    CONSTANTS:
      BEGIN OF c_service,
        github TYPE string VALUE 'github',
        gitlab TYPE string VALUE 'gitlab',
      END OF c_service .

    CLASS-METHODS get_instance
      IMPORTING
        !iv_service             TYPE string
        !is_repo                TYPE ty_repo
        !iv_token               TYPE string
        !iv_ssl_id              TYPE ssfapplssl DEFAULT 'ANONYM'
        !iv_proxy_url           TYPE string OPTIONAL
        !iv_proxy_port          TYPE string OPTIONAL
      RETURNING
        VALUE(ri_repo_logo_git) TYPE REF TO zif_rl_repo_logo_git.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_RL_REPO_LOGO_FACTORY IMPLEMENTATION.


  METHOD get_instance.

    CASE iv_service.
      WHEN c_service-github.

        CREATE OBJECT ri_repo_logo_git
          TYPE zcl_rl_repo_logo_github
          EXPORTING
            is_repo       = is_repo
            iv_token      = iv_token
            iv_ssl_id     = iv_ssl_id
            iv_proxy_url  = iv_proxy_url
            iv_proxy_port = iv_proxy_port.

      WHEN c_service-gitlab.

        CREATE OBJECT ri_repo_logo_git
          TYPE zcl_rl_repo_logo_gitlab
          EXPORTING
            is_repo       = is_repo
            iv_token      = iv_token
            iv_ssl_id     = iv_ssl_id
            iv_proxy_url  = iv_proxy_url
            iv_proxy_port = iv_proxy_port.

      WHEN OTHERS.
*        TODO: raise Exception
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
