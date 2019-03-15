function Get-GitBehindStatus {
[CmdletBinding()]
param (
    [string] $differenceBranch = 'origin/master',
    [string] $referenceBranch,
    [switch] $ShowAhead = $false

)

    $gitCmd = "git status"
    $BranchStatus = & Invoke-Expression $gitCmd 
    if ($null -eq $BranchStatus) {
        throw "Error calling git status.  Are you in a repository? Is git installed?"
    }
    Write-Verbose ($BranchStatus | out-string)


    if ([string]::IsNullOrEmpty($referenceBranch)) {
        $referenceBranch = $BranchStatus[0].Replace('On branch ','')
    }


    Write-Verbose "Comparing local branch '$referenceBranch' with remote branch '$differenceBranch'.."

    
    $gitCmd = "git fetch --all"
    Write-Verbose "Calling $gitCmd"
    $gitFetch = & Invoke-Expression $gitCmd  2>&1
    if ($null -eq $gitFetch) {
        throw "Error calling git fetch."
    }
    Write-Verbose  $gitFetch
   


    $gitCmd = "git rev-list --left-right --count $differenceBranch...$referenceBranch"
    Write-Verbose "Calling $gitCmd"
    $gitRevList = & Invoke-Expression $gitCmd 
    if ($null -eq $gitRevList) {
        throw "Error calling git rev-list.  Is the remote branch '$differenceBranch' correct?"
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


    $Msg = "Branch '$referenceBranch' is behind '$differenceBranch' by $behindBy commits"

    if ($ShowAhead) {
        $Msg = "$Msg and ahead by $aheadBy commits"
    }
    else {
         $Msg = "$Msg."
    }


    Write-Host $Msg -ForegroundColor $fgCol

}




