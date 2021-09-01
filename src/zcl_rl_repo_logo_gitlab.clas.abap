CLASS zcl_rl_repo_logo_gitlab DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES zif_rl_repo_logo_git.

    ALIASES get
      FOR zif_rl_repo_logo_git~get.

    METHODS constructor
      IMPORTING
        !is_repo       TYPE zcl_rl_repo_logo_factory=>ty_repo
        !iv_token      TYPE string
        !iv_ssl_id     TYPE ssfapplssl DEFAULT 'ANONYM'
        !iv_proxy_url  TYPE string OPTIONAL
        !iv_proxy_port TYPE string OPTIONAL.
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      BEGIN OF ty_avatarurl,
        avatarurl TYPE string,
      END OF ty_avatarurl.
    TYPES:
      BEGIN OF ty_project,
        project TYPE ty_avatarurl,
      END OF ty_project.
    TYPES:
      BEGIN OF ty_response,
        data TYPE ty_project,
      END OF ty_response.

    DATA mv_url TYPE string.
    DATA mv_token TYPE string.
    DATA ms_repo TYPE zcl_rl_repo_logo_factory=>ty_repo .
    DATA mv_ssl_id TYPE ssfapplssl.
    DATA mv_proxy_url TYPE string.
    DATA mv_proxy_port TYPE string.

    METHODS get_repo_logo
      IMPORTING
        !iv_url             TYPE string
      RETURNING
        VALUE(ri_repo_logo) TYPE REF TO zif_rl_repo_logo.
    METHODS create_query
      RETURNING
        VALUE(rv_query) TYPE string.
    METHODS get_logo_url
      RETURNING
        VALUE(rv_url) TYPE string.
    METHODS create_http_client
      IMPORTING
        !iv_url          TYPE string
      RETURNING
        VALUE(ri_client) TYPE REF TO if_http_client.
ENDCLASS.



CLASS ZCL_RL_REPO_LOGO_GITLAB IMPLEMENTATION.


  METHOD constructor.

    mv_url = 'https://gitlab.com/api/graphql'.
    mv_token = iv_token.
    ms_repo = is_repo.
    mv_ssl_id = iv_ssl_id.
    mv_proxy_url = iv_proxy_url.
    mv_proxy_port = iv_proxy_port.

  ENDMETHOD.


  METHOD create_http_client.

    cl_http_client=>create_by_url(
      EXPORTING
        url                = iv_url
        ssl_id             = mv_ssl_id
        proxy_host         = mv_proxy_url
        proxy_service      = mv_proxy_port
      IMPORTING
        client             = ri_client
      EXCEPTIONS
        argument_not_found = 1
        plugin_not_active  = 2
        internal_error     = 3
        OTHERS             = 4 ).
    IF sy-subrc <> 0.
      CASE sy-subrc.
        WHEN 1.
        WHEN OTHERS.
      ENDCASE.
*      exception raise
    ENDIF.

  ENDMETHOD.


  METHOD create_query.

    rv_query = `{ "query": "{ project( fullPath: \"` && ms_repo-owner && `/` &&  ms_repo-name && `\" )` &&
               `{ avatarUrl } }" }`.

*{ "query": "{ project( fullPath: \"victorizbitskiy/zconcurrency_api\" ){ avatarUrl } }" }
  ENDMETHOD.


  METHOD get_logo_url.

    DATA lr_http_client TYPE REF TO if_http_client.
    DATA lv_query TYPE string.
    DATA lv_code    TYPE i.
    DATA lv_message TYPE string.
    DATA lv_text    TYPE string.
    DATA lv_response_json TYPE string.
    DATA ls_response_abap TYPE ty_response.
    DATA lv_auth_value TYPE string.

    lr_http_client = create_http_client( iv_url = mv_url ).
    lr_http_client->propertytype_logon_popup = lr_http_client->co_disabled.
    lr_http_client->request->set_method( if_http_request=>co_request_method_post ).
    lr_http_client->request->set_content_type( 'application/json' ).

    lr_http_client->request->set_header_field( name  = 'Accept'
                                               value = 'application/json' ).
    lv_auth_value = |Bearer { mv_token }|.
    lr_http_client->request->set_header_field( name  = 'Authorization'
                                               value = lv_auth_value ).
    lv_query = create_query( ).
    lr_http_client->request->set_cdata( lv_query ).

    lr_http_client->send(
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3
        http_invalid_timeout       = 4
        OTHERS                     = 5 ).

    IF sy-subrc = 0.
      lr_http_client->receive(
        EXCEPTIONS
          http_communication_failure = 1
          http_invalid_state         = 2
          http_processing_failed     = 3
          OTHERS                     = 4 ).
    ENDIF.

    IF sy-subrc <> 0.
      lr_http_client->get_last_error(
        IMPORTING
          code = lv_code
          message = lv_message ).

      lv_text = |HTTP error { lv_code } occured: { lv_message }|.

*TODO raise exception
    ENDIF.

    lv_response_json = lr_http_client->response->get_cdata( ).
    lr_http_client->close( ).

    /ui2/cl_json=>deserialize( EXPORTING json = lv_response_json
                                         pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                CHANGING data = ls_response_abap ).

    rv_url = ls_response_abap-data-project-avatarurl.

  ENDMETHOD.


  METHOD get_repo_logo.

    DATA li_http_client TYPE REF TO if_http_client.
    DATA lv_code    TYPE i.
    DATA lv_message TYPE string.
    DATA lv_text    TYPE string.
    DATA lv_type TYPE string.
    DATA lv_extension TYPE string.
    DATA lv_response_data TYPE xstring.
    DATA lv_content_type TYPE string.

    li_http_client = create_http_client( iv_url = iv_url ).
    li_http_client->propertytype_logon_popup = li_http_client->co_disabled.
    li_http_client->request->set_method( if_http_request=>co_request_method_get ).

    li_http_client->send(
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3
        http_invalid_timeout       = 4
        OTHERS                     = 5 ).

    IF sy-subrc = 0.
      li_http_client->receive(
        EXCEPTIONS
          http_communication_failure = 1
          http_invalid_state         = 2
          http_processing_failed     = 3
          OTHERS                     = 4 ).
    ENDIF.

    IF sy-subrc <> 0.
      li_http_client->get_last_error(
        IMPORTING
          code = lv_code
          message = lv_message ).

      lv_text = |HTTP error { lv_code } occured: { lv_message }|.
*     TODO raise exception

    ENDIF.

    lv_response_data = li_http_client->response->get_data( ).
    lv_content_type = li_http_client->response->if_http_entity~get_content_type( ).
    li_http_client->close( ).

    SPLIT lv_content_type AT '/' INTO lv_type lv_extension.

    CREATE OBJECT ri_repo_logo
      TYPE zcl_rl_repo_logo
      EXPORTING
        iv_logo      = lv_response_data
        iv_extension = lv_extension.

  ENDMETHOD.


  METHOD zif_rl_repo_logo_git~get.

    DATA lv_logo_url TYPE string.

    lv_logo_url = get_logo_url( ).
    ri_repo_logo = get_repo_logo( lv_logo_url ).

  ENDMETHOD.
ENDCLASS.
