# Approaches of working with variables / global config

Currently there are 2 different versions of mapping the configs to the modules:

1. Using the old way of re-defining the config variables
    - non-DRY (do-it-yourself) method
    - reccomended by HashiCorp
    - **current use**

2. By using a global modules
    - not recommened by HashiCorp
    - follows DRY method
    - **currently commented**




## Useful commands for debugging ec2 passbolt instance

View error logs:

```bash
sudo cat /var/log/passbolt/error.log
```

Try to change php.ini file at

```bash
sudo nano /etc/php/8.2/fpm/php.ini # There is also another php.ini file at 8.2/cli/php.ini if for some reason the first file change doesn't help
```

and try to find 2 php variables:

- allow_url_fopen = Off
- allow_url_include = Off

Change both of their values to `On`.
Now restart the web server:

```bash
sudo systemctl restart php8.2-fpm
```
