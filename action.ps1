try {
    $searchValue = $dataSource.searchUser
    $searchQuery = "*$searchValue*"
    $searchOUs = $ADusersSearchOU

    Import-Module ActiveDirectory -ErrorAction Stop
     
    if([String]::IsNullOrEmpty($searchValue) -eq $true){
        return
    }else{
        Write-Information "SearchQuery: $searchQuery"
        Write-Information "SearchBase: $searchOUs"
         
        $ous = $searchOUs | ConvertFrom-Json
        $filter = {
            Name -like $searchQuery -or
            DisplayName -like $searchQuery -or
            userPrincipalName -like $searchQuery -or
            mail -like $searchQuery
        }

        $users = foreach($item in $ous) {
            $params = @{
                Filter      = $filter;
                SearchBase  = $item.ou;
                Properties  = 'SamAccountName', 'displayName', 'UserPrincipalName', 'Description', 'company', 'Department', 'Title';
            }

            Get-ADUser @params
        }
         
        $users = $users | Sort-Object -Property DisplayName
        $resultCount = @($users).Count
        Write-Information "Result count: $resultCount"
         
        if($resultCount -gt 0){
            foreach($user in $users){
                $returnObject = @{
                    SamAccountName      = $user.SamAccountName;
                    displayName         = $user.displayName;
                    UserPrincipalName   = $user.UserPrincipalName;
                    Description         = $user.Description;
                    Company             = $user.company;
                    Department          = $user.Department;
                    Title               = $user.Title;
                }
                
                Write-Output $returnObject
            }
        }
    }
} catch {
    $msg = "Error searching AD user [$searchValue]. Error: $($_.Exception.Message)"
    Write-Error $msg
}