###
# Danny Davis
# twitter: twitter.com/pko3
# github: github.com/pkothree
# Created: 02/06/16
# Modified: 02/08/16
# Description: Configure Kerberos
###

# Example for Domain: "SP"
# Example for HTTP/DNS-Value: "HTTP/sprocks.io"
# Example for SP/ACCOUNT: "SP/spfarm"
# Example for SERVERNAMEFQDN: servername.domain.com
# Clarification: Accountnames for Instances are named after the Instance
#
# -spnValues:
# you have to add the trust delegation to the accounts
# f.ex. Excel is supposed to trust the relational instance,
# so the code would look like this:
# set-kerbuser -Identity "DOMAIN\EXCEL" -spnValues "SP/EXCEL", "MSSQLSvc/SERVERNAMEFQDN:PORT", "MSSQLSvc/SERVERNAME:PORT"


Start-Transcript -path ".\KerbConfig.log"

Import-Module ActiveDirectory
Import-Module ".\KerbMod.ps1"

##################################
# Create SPNs in Active Directory#
##################################

# SharePoint App Pool
set-kerbuser -Identity "DOMAIN\APP-POOL-Account" -spnValues "HTTP/DNS-VALUE"
# Farm / Setup Account
set-kerbuser -Identity "DOMAIN\FARM-ACCOUNT" -spnValues "HTTP/DNS-VALUE"
# Excel / Visio
set-kerbuser -Identity "DOMAIN\EXCEL" -spnValues "SP/EXCEL"
# Claims to Windows Token / C2WTS
set-kerbuser -Identity "DOMAIN\C2WTS" -spnValues "SP/C2WTS"
# SPN for WS-Management of CA Server (used for CredSSP authentication of remote management)
set-kerbuser -Identity "DOMAIN\SERVERNAME" -spnValues "WSMAN/SERVERNAME", "WSMAN/SERVERNAMEFQDN"
# SPNs for Analysis Server Service Account
set-kerbuser -Identity "DOMAIN\TABULARINSTANCE" -spnValues "MSOLAPSvc.3/SERVERNAMEFQDN:TABULARINSTANCE", "MSOLAPSvc.3/SERVERNAME:TABULARINSTANCE", "MSOLAPDisco.3/SERVERNAMEFQDN:TABULARINSTANCE"
# SPNs for SQL Server Service Account
set-kerbuser -Identity "DOMAIN\RELATIONALINSTANCE" -spnValues "MSSQLSvc/SERVERNAMEFQDN:PORT"
set-kerbuser -Identity "DOMAIN\RELATIONALINSTANCE" -spnValues "MSSQLSvc/SERVERNAME:PORT"


###############################################
# Create Trust Delegations in Active Directory#
###############################################
# IMPORTANT: take a close look at the changes and differences to the code above
# For different trusts, you would have to change the code as follows:
#
# SharePoint App Pool
#set-kerbuser -Identity "DOMAIN\APP-POOL-Account" -spnValues "HTTP/DNS-VALUE",
# Farm / Setup Account, -spnValues could be "HTTP/sprocks.io", "HTTP/SERVERNAME" or "HTTP/SERVERNAMEFQDN", "MSOLAPSvc.3/SERVERNAMEFQDN:TABULARINSTANCE", "MSOLAPSvc.3/SERVERNAME:TABULARINSTANCE", "MSOLAPDisco.3/SERVERNAMEFQDN:TABULARINSTANCE"
#set-kerbuser -Identity "DOMAIN\FARM-ACCOUNT" -spnValues "HTTP/DNS-VALUE", "HTTP/sprocks.io"
# Excel / Visio
#set-kerbuser -Identity "DOMAIN\EXCEL" -spnValues "SP/EXCEL", "MSSQLSvc/SERVERNAMEFQDN:PORT", "MSSQLSvc/SERVERNAME:PORT", "MSOLAPSvc.3/SERVERNAMEFQDN:TABULARINSTANCE", "MSOLAPSvc.3/SERVERNAME:TABULARINSTANCE", "MSOLAPDisco.3/SERVERNAMEFQDN:TABULARINSTANCE"
# Claims to Windows Token / C2WTS
#set-kerbuser -Identity "DOMAIN\C2WTS" -spnValues "SP/C2WTS", "HTTP/DNS-VALUE", "MSSQLSvc/SERVERNAMEFQDN:PORT", "MSSQLSvc/SERVERNAME:PORT", "MSOLAPSvc.3/SERVERNAMEFQDN:TABULARINSTANCE", "MSOLAPSvc.3/SERVERNAME:TABULARINSTANCE", "MSOLAPDisco.3/SERVERNAMEFQDN:TABULARINSTANCE"
# SPN for WS-Management of CA Server (used for CredSSP authentication of remote management)
#set-kerbuser -Identity "DOMAIN\SERVERNAME" -spnValues "WSMAN/SERVERNAME", "WSMAN/SERVERNAMEFQDN"
# SPNs for Analysis Server Service Account
#set-kerbuser -Identity "DOMAIN\TABULARINSTANCE" -spnValues "MSOLAPSvc.3/SERVERNAMEFQDN:TABULARINSTANCE", "MSOLAPSvc.3/SERVERNAME:TABULARINSTANCE", "MSOLAPDisco.3/SERVERNAMEFQDN:TABULARINSTANCE"
#set-kerbuser -Identity "DOMAIN\TABULARINSTANCE" -spnValues "MSOLAPSvc.3/SERVERNAME:TABULARINSTANCE"
#set-kerbuser -Identity "DOMAIN\TABULARINSTANCE" -spnValues "MSOLAPDisco.3/SERVERNAMEFQDN:TABULARINSTANCE"
# SPNs for SQL Server Service Account (relational Instance)
#set-kerbuser -Identity "DOMAIN\RELATIONALINSTANCE" -spnValues "MSSQLSvc/SERVERNAMEFQDN:PORT"
#set-kerbuser -Identity "DOMAIN\RELATIONALINSTANCE" -spnValues "MSSQLSvc/SERVERNAME:PORT"

Stop-Transcript
