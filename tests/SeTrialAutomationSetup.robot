*** Settings ***
Resource                    ../resources/common.robot

*** Test Cases ***
Authenticate to Github
    browserSetup
    GithubLogin

Authenticate to salesforce
    sfdcLogin

Create Github Repo
    GoTo                            https://github.com
    ClickText                       New
    ClickText                       Repository name
    TypeText                        Repository name        ${gitRepoName}
    ClickCheckbox                   Add .gitignore             on
    ClickText                       None
    ClickText                       Actionscript
    ClickText                       Create repository         

Create Git Repo Record and Production Snapshot
    GoTo                    ${login_url}
    LaunchApp               Git Repositories
    ClickText               New        Change Owner
    TypeText                thePage:theForm:pb_editGit:pbsMain:gitreponame:name    input_text=${trialCompany} Trail Repo
    TypeText                URI                        input_text=${repoUrl}
    DropDown                Git Provider               Github
    TypeText                Branch Base URL            input_text=${base}tree/
    TypeText                Commit Base URL            input_text=${base}commit/
    TypeText                Pull Request Base URL      input_text=${base}
    TypeText                Tag Base URL               input_text=${base}tags/
    ClickText               Save
    ClickText               Create SSH Keys            delay=2
    ClickText               View                       delay=5
    ClickElement            //*[@id\="wrap"]           delay=2
    CopyText                //*[@id\="wrap"]
    ${sshKey}=              GetInputValue              //*[@id\="wrap"]
    GoTo                    https://github.com/
    #ClickText               Sign in
    #TypeText                Username or email address  ${gitUser}
    #TypeSecret              Password                   ${gitPassword}
    #ClickText               Sign in
    ClickItem               @${gitUser}
    ClickText               Settings
    ClickText               SSH and GPG keys
    ClickText               New SSH key
    ClickText               Title
    TypeText                Title                      ${trialCompany} Trial SSH
    ClickText               Key
    TypeText                Key                        ${sshKey}
    ClickText               Add SSH key
    GoTo                    ${login_url}lightning/o/copado__Git_Backup__c/list
    ClickText               New
    UseTable                xpath\=//*[@id\='thePage:theForm:pb_viewGitBackup:j_id153']/div[2]/table[1]
    ClickCell               r1c1
    WriteText               production
    TypeText                Git Repository             ${trialCompany} Trail Repo
    TypeText                Branch                     main
    TypeText                Credential                 PROD
    ClickText               Save
    ClickText               Take Snapshot Now
    ClickText               OK
    FOR         ${i}    IN RANGE    10                                                               # Loop for 10 times
        sleep                       30s                                                              # check every 30 seconds
        ${isFound} =                IsText                       Hide Message           5s           # look for "Hide Message" within 5 seconds
        Exit For Loop If            not ${isFound}                                              # Exit the loop when Hide Message is no longer found
    END 

Create Github branches
    #GithubLogin
    Goto                    ${base}    
    ClickText               main
    
    FOR    ${var}      IN    @{environmentNames} 
         WriteText               ${var}
         ClickText               Create branch    delay=5
         ClickText               ${var}
    END

Create Remaining SFDC Snapshots
    GoTo                    ${login_url}     
    LaunchApp               Copado Pipeline Manager
    # ClickText               App Launcher
    # TypeText                Search apps and items...    Copado Pipeline Manager    delay=2
    # ClickText               Copado Pipeline Manager     delay=3
    FOR    ${envVar}    IN    @{environmentNames}
        ClickText               Git Snapshots               More    delay=3
        ClickText               New
        UseTable                xpath\=//*[@id\='thePage:theForm:pb_viewGitBackup:j_id153']/div[2]/table[1]
        ClickCell               r1c1
        WriteText               ${envVar}
        ClickCell               r2c1
        WriteText               ${trialCompany} Trail Repo
        TypeText                Branch                     ${envVar}
        DropDown                Allow Snapshots & Commits                    Allow Commits Only
        TypeText                Credential                 ${envVar}
        ClickText               Save    
    END

Create Pipeline and Pipeline Connections
    ClickText    Pipelines    anchor=Pipeline Manager
    ClickText    New          anchor=Change Owner    delay=2
    ClickText    Pipeline Name   2                   delay=2
    WriteText    ${trialCompany} Trail Pipeline 
    IF    '${platform}' == 'SFDX'
            ClickText    Salesforce       anchor=Platform
            ClickText             SFDX    anchor=Other               
    END
    TypeText    Git Repository            ${trialCompany} Trail Repo
    ClickText             ${trialCompany} Trail Repo    2
    TypeText    Main Branch               main
    ClickCheckbox                 Active    on
    ClickText                     Save      2
    ClickText         Pipeline Connections
    ClickText         New
    ClickText         Source Environment          delay=2
    TypeText          Source Environment          DEV1
    ClickText         DEV1                        2
    ClickText         Destination Environment
    TypeText          Destination Environment     INT
    ClickText         INT                        2
    ClickText         Branch
    TypeText          Branch                      dev1
    ClickText         Save                        2
    ClickText         New
    ClickText         Source Environment          delay=2
    TypeText          Source Environment          DEV2
    ClickText         DEV2                        2
    ClickText         Destination Environment
    TypeText          Destination Environment     INT
    ClickText         INT                        2
    ClickText         Branch
    TypeText          Branch                      dev2
    ClickText         Save                        2
    ClickText         New
    ClickText         Source Environment          delay=2
    TypeText          Source Environment          INT
    ClickText         INT                        2
    ClickText         Destination Environment
    TypeText          Destination Environment     UAT
    ClickText         UAT                      2
    ClickText         Branch
    TypeText          Branch                      int
    ClickText         Save                        2
    ClickText         New
    ClickText         Source Environment          delay=2
    TypeText          Source Environment          UAT
    ClickText         UAT                        2
    ClickText         Destination Environment
    TypeText          Destination Environment     PROD
    ClickText         PRODUpdate                        2
    ClickText         Branch
    TypeText          Branch                      uat
    ClickText         Save                        2
    ClickText         Pipeline Manager            1

    
    
    