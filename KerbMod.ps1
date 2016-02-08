###
# Danny Davis
# twitter: twitter.com/pko3
# github: github.com/pkothree
# Created: 02/08/16
# Modified: 02/08/16
# Description: Configure Kerberos (Module file)
###

function set-kerbuser{
  [CmdletBinding()]
  param(
    [Parameter(Mandatory=$true)][ValidateNotNull()]$identity,
    [string[]]$spnValues
  )
  begin{}
  process{
    $delegationProperty = "msDS-AllowedToDelegateTo"
    $account = Get-AdUser $identity
    Write-Host $account
    foreach($spnValue in $spnValues)
    {
      #Set the service principal name
      Set-ADUser -identity $account -servicePrincipalName $spnValue
      Write-Host "SPN set for "+$spnValue
      #Set the delegation to the service principal name
      Set-ADObject $account -add @{$delegationProperty=$spnValue}
      Write-Host "Delegation set for Account "+$account+" and SPN "+$spnValue
      #Set the Account Control to allow unconstrained delegations
      Set-ADAccountControl $account -TrustedToAuthForDelegation $true
    }
  }
}
