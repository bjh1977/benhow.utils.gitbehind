function Get-GitBehindStatus {
[CmdletBinding()]
param (
    [string] $remoteBranch = 'origin/int',
    [string] $localBranch,
    [boolean] $ShowAhead = $false

)

    Write-Verbose "Comparing with remote branch '$remoteBranch'.."

    $BranchStatus = git status

    if ($null -eq $BranchStatus) {
        throw "Error calling git status.  Are you in a repository? Is git installed?"
    }

    if ([string]::IsNullOrEmpty($localBranch)) {
        $localBranch = $BranchStatus[0].Replace('On branch ','')
    }


    $gitCmd = "git rev-list --left-right --count $remoteBranch...$localBranch"
    $gitRevList = & Invoke-Expression $gitCmd 
    if ($null -eq $gitRevList) {
        throw "Error calling git rev-list.  Is the remote branch '$remoteBranch' correct?"
    }


    $behindBy = ($gitRevList -split '\t')[0]
    $aheadBy = ($gitRevList -split '\t')[1]

    if ($behindBy -gt 0) {
        $fgCol = 'magenta'    
    }
    else {
        $fgCol = 'green'    
    }


    $Msg = "Branch '$localBranch' is behind '$remoteBranch' by $behindBy commits"

    if ($ShowAhead) {
        $Msg = "$Msg and ahead by $aheadBy commits"
    }
    else {
         $Msg = "$Msg."
    }


    Write-Host $Msg -ForegroundColor $fgCol

}




