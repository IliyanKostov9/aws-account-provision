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
5. Go to the new account hosted zone and click the button `Import hosted file`
6. In here copy the output to the text box and voalla, it's done!
