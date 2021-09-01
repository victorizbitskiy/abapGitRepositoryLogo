INTERFACE zif_rl_repo_logo
  PUBLIC.

  METHODS get
    RETURNING
      VALUE(rv_logo) TYPE xstring.
  METHODS get_extension
    RETURNING
      VALUE(rv_extension) TYPE string.

ENDINTERFACE.
