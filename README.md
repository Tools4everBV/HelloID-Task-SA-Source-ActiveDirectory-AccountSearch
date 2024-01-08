# HelloID-Task-SA-Source-ActiveDirectory-AccountSearch

## Prerequisites

- [ ] The HelloID SA on-premises agent installed
- [ ] The ActiveDirectory module is installed on the server where the HelloID SA on-premises agent is running.
- [ ] User-defined variable `ADusersSearchOU` created in your HelloID portal. Containing a Json string array of Active Directory OU's to search in.

Example value 
```json
[{ "OU": "OU=Disabled Users,DC=helloid,DC=local"},{ "OU": "OU=Users,DC=helloid,DC=local"},{"OU": "OU=External,DC=helloid,DC=local"}]
```

## Description

This code snippet executes the following tasks:

1. Imports the ActiveDirectory module.
2. Define a wildcard search query `$searchQuery` based on the search parameter `$datasource.searchUser`
3. Loop through the list of AD search OU's defined in the User-defined variable `ADusersSearchOU` and retrieve the AD users using the `Get-ADUser` cmdlet.

> The filter property **-filter** accepts different values [See the Microsoft Docs page](https://learn.microsoft.com/en-us/powershell/module/activedirectory/get-aduser?view=windowsserver2022-ps)

4. Return a hash table for each user account using the `Write-Output` cmdlet.

> To view an example of the data source output, please refer to the JSON code pasted below.

```json
{
    "searchUser": "James"
}
```