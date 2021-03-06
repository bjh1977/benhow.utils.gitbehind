# gitbehind

Quickly compare a branch with another to find out how many commits behind (and optionally, ahead) it is.  Requires git to be installed.

The module is available in the [Powershell Gallery](https://www.powershellgallery.com/packages/gitbehind/0.0.1) and can be installed by calling

```
Install-Module -Name gitbehind
```

There's only one function - `Get-GitBehind` - which takes the following parameters:

 `ReferenceBranch` - 
The branch you're referring to. Defaults to your current branch

`DifferenceBranch` - 
The branch you want to compare against the reference branch. Defaults to origin/master.

`ShowAhead` -
Supply this switch parameter to also get the number of commits ahead of the difference branch.

### Examples

Compare your current branch against origin/master
```
cd C:\your\repo
Get-GitBehind 
```

Explicitly set branches to compare
```
cd C:\your\repo
$ReferenceBranch = "feature/myfeature"
$DifferenceBranch = "origin/master"
Get-GitBehind -ReferenceBranch $ReferenceBranch -DifferenceBranch $DifferenceBranch
```

Use your current branch as the reference branch
```
cd C:\your\repo
$ReferenceBranch = "feature/myfeature"
$DifferenceBranch = "origin/master"
Get-GitBehind -DifferenceBranch $DifferenceBranch 
```