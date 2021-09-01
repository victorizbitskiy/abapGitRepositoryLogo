[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/victorizbitskiy/zconcurrency_api/blob/main/LICENSE)
![ABAP 7.00+](https://img.shields.io/badge/ABAP-7.02%2B-brightgreen)

# abapGitRepositoryLogo
A tool to get the logo of a git repository.

Works with: [GitHub](https://github.com/), [GitLab](https://gitlab.com/).

## Usage
#### 1) GitHub
For example, you need to get the [logo of a GitHub repository](https://docs.github.com/en/github/administering-a-repository/managing-repository-settings/customizing-your-repositorys-social-media-preview). You can do it like this:
```abap
    DATA ls_repo TYPE zcl_rl_repo_logo_factory=>ty_repo.
    DATA lv_token TYPE string.
    DATA li_repo_logo_github TYPE REF TO zcl_rl_repo_logo_github.
    DATA li_repo_logo TYPE REF TO zif_rl_repo_logo.
    DATA lv_repo_logo TYPE xstring.
    DATA lv_extension TYPE string.
    
    ls_repo-owner = 'octocat'.
    ls_repo-name = 'Hello-World'.
    lv_token = '<YOUR GITHUB TOKEN>'.

    li_repo_logo_github ?= zcl_rl_repo_logo_factory=>get_instance( iv_service = 'github'
                                                                   is_repo    = ls_repo
                                                                   iv_token   = lv_token ).                                   
    li_repo_logo  = li_repo_logo_github->get(  ).
    lv_logo       = li_repo_logo->get( ).
    lv_extension  = li_logo->get_extension( ).
````
#### 2) GitLab
If you need to get the [logo of a GitLab repository](https://docs.gitlab.com/ee/user/project/settings/) you can do it like this:
```abap
    DATA ls_repo TYPE zcl_rl_repo_logo_factory=>ty_repo.
    DATA lv_token TYPE string.
    DATA li_repo_logo_gitlab TYPE REF TO zcl_rl_repo_logo_gitlab.
    DATA li_repo_logo TYPE REF TO zif_rl_repo_logo.
    DATA lv_repo_logo TYPE xstring.
    DATA lv_extension TYPE string.
    
    ls_repo-owner = 'gitlab-org'.
    ls_repo-name = 'gitlab'.
    lv_token = '<YOUR GITLAB TOKEN>'.

    li_repo_logo_gitlab ?= zcl_rl_repo_logo_factory=>get_instance( iv_service = 'gitlab'
                                                                   is_repo    = ls_repo
                                                                   iv_token   = lv_token ).                                   
    li_repo_logo  = li_repo_logo_gitlab->get(  ).
    lv_logo       = li_repo_logo->get( ).
    lv_extension  = li_logo->get_extension( ).
    
```abap
