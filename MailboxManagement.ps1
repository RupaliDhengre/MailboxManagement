Connect-ExchangeOnline -Credential $Creds 
$mbx=Get-Mailbox -ResultSize Unlimited |Select Identity,PrimarySMTPaddress,InPlaceHolds,LitigationHoldEnabled,RetentionHoldEnabled
$path = "C:\PowerShell\Scripts\MailboxStatistics"
$append = "_$(Get-Date -f yy-MM-dd_hh-mm)"

Foreach($i in $mbx)
{

$size=Get-MailboxStatistics -Identity $i.PrimarySMTPaddress|Select @{n="Deleted Items Folder(GB)";e={[math]::Round(($_.TotalDeletedItemSize.ToString().Split("(")[1].Split(" ")[0].Replace(",","")/1GB),2)}},TotalItemSize

 $info = New-Object -TypeName psobject
 $info | Add-Member -MemberType NoteProperty -Name "Identity" -Value $i.Identity
 $info | Add-Member -MemberType NoteProperty -Name "PrimarySMTPaddress" -Value $i.PrimarySMTPaddress
 $info | Add-Member -MemberType NoteProperty -Name "Deleted Item Folder Size" -Value $size.'Deleted Items Folder(GB)'
 $info | Add-Member -MemberType NoteProperty -Name "Mailbox Used Size" -Value $size.TotalItemSize
 $info | Add-Member -MemberType NoteProperty -Name "InPlaceHolds" -Value $i.InPlaceHolds
 $info | Add-Member -MemberType NoteProperty -Name "LitigationHoldEnabled" -Value $i.LitigationHoldEnabled
 $info | Add-Member -MemberType NoteProperty -Name "RetentionHoldEnabled" -Value $i.RetentionHoldEnabled
 $info
 $info|Export-Csv -NoTypeInformation -Path ("{0}\Mailbox Statistics{1}.csv" -f $path, $append) -Append

 }
