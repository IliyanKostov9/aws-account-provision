# Setup VPN
> Doc: https://openvpn.net/as-docs/general.html

1. Updating package repository...

```bash
sudo apt-get update && sudo apt full-upgrade -y
```

2. Now generating a certificate. Make sure to add the IP address to the hosted zone A record!

```bash
export DOMAIN=vpn.ikostov.org

sudo apt install certbot -y
sudo certbot certonly --standalone -d $DOMAIN
cd /usr/local/openvpn_as/scripts/
sudo ./sacli --key "cs.priv_key" --value_file "/etc/letsencrypt/live/$DOMAIN/privkey.pem" ConfigPut
sudo ./sacli --key "cs.cert" --value_file "/etc/letsencrypt/live/$DOMAIN/cert.pem" ConfigPut
sudo ./sacli --key "cs.ca_bundle" --value_file "/etc/letsencrypt/live/$DOMAIN/chain.pem" ConfigPut
sudo ./sacli start
```

4. Certificate signed! Now setting up HSTS...

```bash
sudo sacli --key "cs.http_headers.0" --value "Strict-Transport-Security: max-age=63072000; includeSubDomains" ConfigPut
sudo sacli start
```

5. [Optional] HSTS done! Now setting up HTTP to HTTPS...

```bash
sudo tee /usr/local/openvpn_as/port80redirect.py > /dev/null << 'EOF'
```
<details>
    <summary>
        Python code
    </summary>

    ```python
    import http.server
    import socketserver

    DOMAIN = "vpn.ikostov.org"

    class MyHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
    print("Request received, sending redirect...")
    self.send_response(301)
    self.send_header("Location", f"https://{DOMAIN}")
    self.end_headers()

    PORT = 80
    handler = socketserver.TCPServer(("", PORT), MyHandler)
    print("Serving at port 80")
    handler.serve_forever()
    EOF
    ```

    - crontab is going to be opened

    ```bash
    echo "@reboot /usr/bin/screen -dmS port80redirect /usr/bin/python /usr/local/openvpn_as/port80redirect.py"
    crontab -e
    ```
</details>

6. HTTP to HTTPS done! Now setting up IPv6 from global pool...

```bash
sudo ./sacli --key "vpn.routing6.enable" --value "true" ConfigPut
sudo ./sacli --key "vpn.client.routing6.reroute_gw" --value "true" ConfigPut
sudo ./sacli --key "vpn.server.daemon.vpn_network6.0" --value "fd4a:e7ae:b84b:2::/112" ConfigPut
sudo ./sacli --key "vpn.server.routing6.snat_source.0" --value "eth0:2604:a880:400:d0::189e:6005" ConfigPut
sudo ./sacli start
```

7. IPv6 setup completed! Now setting up DCO for further performance...

```bash
sudo apt install openvpn-dco-dkms -y
sudo sacli -k "vpn.server.daemon.ovpndco" -v "true" ConfigPut
sudo sacli start
echo "DCO output is:"
ip -details link show | grep "ovpn-dco"
```

8. Now changing from IP to hostname

- Go to the web UI > VPN Server and change the Server Address from the IP to the hostname: vpn.ikostov.org


9. [Optional] If for some reason you need to reset your password...

```bash
cd /usr/local/openvpn_as/scripts
sudo ./sacli --user "openvpn" --key "prop_superuser" --value "true" UserPropPut
sudo ./sacli --user "openvpn" --key "user_auth_type" --value "local" UserPropPut
sudo ./sacli --user "openvpn" --new_pass=<PASSWORD> SetLocalPassword
sudo ./sacli start
```

10. DCO completed. Finishing now... Nice. All finished. Now go to your VPN server and download your profile, then move it ./backup/openvpn with a name: 'personalVPN-ovpn.ovpn' and hit ENTER to finish the setup!

```bash
sudo cp openvpn/personalVPN.ovpn /var/lib/openvpn/personalVPN.ovpn
```
