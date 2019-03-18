function Get-GitBehind {
<#
.Synopsis
Compare a branch with another to find out how many commits behind it is.
.Description
Compare a branch with another to find out how many commits behind (and optionally, ahead) it is. Requires git to be installed. "git fetch" is called each time the function is called.
.Parameter ReferenceBranch
The branch you're referring to. Defaults to your current branch
.Parameter DifferenceBranch
The branch you want to compare against the reference branch. Defaults to origin/master.
.Parameter ShowAhead
Supply this switcdh parameter to also get the number of commits ahead of the difference branch.
.EXAMPLE
Compare your current branch against origin/master
cd C:\your\repo
Get-GitBehind 
.EXAMPLE
Explicitly set branches to compare
cd C:\your\repo
$ReferenceBranch = "feature/myfeature"
$DifferenceBranch = "origin/master"
Get-GitBehind -ReferenceBranch $ReferenceBranch -DifferenceBranch $DifferenceBranch
.EXAMPLE
Use your current branch as the reference branch
cd C:\your\repo
$ReferenceBranch = "feature/myfeature"
$DifferenceBranch = "origin/master"
Get-GitBehind -DifferenceBranch $DifferenceBranch 
#>
[CmdletBinding()]
param (
    [string] $ReferenceBranch,    
    [string] $DifferenceBranch = 'origin/master',    
    [switch] $ShowAhead = $false

)

    $gitCmd = "git status"
    $BranchStatus = & Invoke-Expression $gitCmd 
    if ($null -eq $BranchStatus) {
        throw "Error calling git status.  Are you in a repository? Is git installed?"
    }
    Write-Verbose ($BranchStatus | out-string)


    if ([string]::IsNullOrEmpty($ReferenceBranch)) {
        $ReferenceBranch = $BranchStatus[0].Replace('On branch ','')
    }


    Write-Verbose "Comparing local branch '$ReferenceBranch' with remote branch '$DifferenceBranch'.."

    
    $gitCmd = "git fetch --all"
    Write-Verbose "Calling $gitCmd"
    $gitFetch = & Invoke-Expression $gitCmd  2>&1
    if ($null -eq $gitFetch) {
        throw "Error calling git fetch."
    }
    Write-Verbose  $gitFetch
   


    $gitCmd = "git rev-list --left-right --count $DifferenceBranch...$ReferenceBranch"
    Write-Verbose "Calling $gitCmd"
    $gitRevList = & Invoke-Expression $gitCmd 
    if ($null -eq $gitRevList) {
        throw "Error calling git rev-list.  Is the remote branch '$DifferenceBranch' correct?"
    }
    Write-Verbose  $gitRevList
    


    $behindBy = ($gitRevList -split '\t')[0]
    $aheadBy = ($gitRevList -split '\t')[1]

    if ($behindBy -gt 0) {
        $fgCol = 'magenta'    
    }
    else {
        $fgCol = 'green'    
    }


    $Msg = "Branch '$ReferenceBranch' is behind '$DifferenceBranch' by $behindBy commits"

    if ($ShowAhead) {
        $Msg = "$Msg and ahead by $aheadBy commits"
    }
    else {
         $Msg = "$Msg."
    }


    Write-Host $Msg -ForegroundColor $fgCol

}




