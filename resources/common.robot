*** Settings ***
Library                 QWeb
Library                 QForce
Library                 String
Documentation           Test suite SE Demo Org
Suite Setup             Open Browser    about:blank    chrome
Suite Teardown          Close All Browsers

*** Variables ***
${trialCompany}           CompanyA
${BROWSER}                chrome
${username}               gposey@mcdxdemoorg.com
${password}               RecordingUser123
${login_url}              https://copado-18e.my.salesforce.com/
${gitUser}                GrahamPosey
${gitPassword}            073084July
${platform}               Salesforce
@{environmentNames}       dev1  dev2  int  uat
${gitRepoName}            ${trialCompany}TrialRepo
${home_url}               ${login_url}/lightning/page/home
${usernameRepo}           ${gitUser}/${gitRepoName}
${repoUrl}                git@github.com:${usernameRepo}.git
${base}                   https://github.com/${usernameRepo}/

*** Keywords ***
browserSetup
    Open Browser            about:blank                 ${BROWSER}
    SetConfig               LineBreak                   ${EMPTY}
    SetConfig               DefaultTimeout              20s 

sfdcLogin                
    GoTo                    ${login_url}
    TypeText                Username    input_text=${username}
    TypeText                Password    input_text=${password}
    ClickElement            //*[@id\="Login"]

GithubLogin
    GoTo                    https://github.com/login
    ClickText               Sign in
    TypeText                Username or email address  ${gitUser}
    TypeSecret              Password                   ${gitPassword}
    ClickText               Sign in