# Instructions for migration hosted file from one account to another

1. Create a hosted zone in the new account with the same hosted name as the TLD domain
2. Log in to AWS SSO via the CLI on the old AWS account and login, in this example the sso account name is named `btg-iliqn`
3. After logging in, do the following commands:

```bash
#!/bin/bash

hostedzoneid=$(aws route53 list-hosted-zones --output json --profile btg-iliqn | jq -r ".HostedZones[] | select(.Name == \"ikostov.org.\") | .Id" | cut -d'/' -f3)

aws route53 list-resource-record-sets --hosted-zone-id $hostedzoneid --profile btg-iliqn --output json | jq -jr '.ResourceRecordSets[] | "\(.Name) \t\(.TTL) \t\(.Type) \t\(.ResourceRecords[]?.Value)\n"'
```

4. Afterwards you'll receive a hosted zone output from the terminal, copy the output
5. Create a new hosted zone manually and pay attention to create it's name save as the registered domain, eg. `ikostov.org`
6. Go to the new account hosted zone and click the button `Import hosted file`
7. In here copy the output to the text box.
8. Finally you need to update the nameservers, that are from the NS record of the hosted zone to be as same as the `Registered domain`
9. Copy the NS from the hosted zone to the registered domain and remove the last dot at the end '.'
10. That's it!
