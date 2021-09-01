INTERFACE zif_rl_repo_logo_git
  PUBLIC.

  METHODS get
    RETURNING
      VALUE(ri_repo_logo) TYPE REF TO zif_rl_repo_logo.

ENDINTERFACE.
