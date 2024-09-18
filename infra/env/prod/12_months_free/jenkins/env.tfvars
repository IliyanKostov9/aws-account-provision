region   = "eu-west-1"
env      = "prod"
app_name = "jenkins"

ec2_name          = "prod-jenkins-ec2-aws"
ec2_ami           = "ami-03cc8375791cb8bcf"
ec2_instance_type = "t2.micro"

ec2_tags = {
  "env" = "prod"
  "app" = "jenkins"
}

ec2_key_pair_name       = "jenkins-key-pair"
ec2_key_pair_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDFh0YIfZg3rtkNZFOgF6AxOFBYmamaRlhEB7mwfvHTHZJ3pD32ncjwTeoLTK36O+7VF5n9ApRh4yfjXh33gTf9okgjyyAOIrOVXU2HJA8rRHS1nD+cZF2Npy0hqFT0LBM+JS6JyoDvXfEM9Mkp6oS3TY54w6UmAHUrKnJ9cHn+C8kCv8EXty2IRmUHE45kTsKnPsu4DBdmYw2MNPWCfAD6DkV+BeTrJ4/VLT53o367QfObyI8kPreivtrVT871TkmOtsUBvOdPUxEm1C5Fc0Q7wDa24U8/K+cwRq2lUv2VkJe2lxeeABNyKpdpsiQnfMMYOi+yoRuhvwOvfkWuGJjjR84lFYVvAZUDLTiZx588U5tUAW8Ap2nUvcP6ODKXLSTFM/EVAyRG4C6W2Xn1AaSOevPnZOJ9ZWDYcygSbUojfKQAOekHECYqRc25XDlWv5jl/Xufci/4p78QWreLOZR4FmxV84OAPbCmN5NRMkKEHaHRKGrVpj2Qcndy9974hm8M0QdgbcC6Flg2dCwaPEnRgXsqGM0nTcReBydB1fYBSSVrwjvzVxncR8a1Cp3POro2kRBIe38a93ngSQJxSCEnIqZ75w1t/cGhJ5gTWQ/UMWXgeHP6zoKknRPDzevCxzbkopKqLpXi2ZxEnbPqSObUbcJg+rwXkT7eTSVIp3gFoQ== ikostov2@baks"


ec2_remote_exec_commands = [
  "sudo apt-get update",
  "sudo apt install fontconfig openjdk-17-jre -y",
  "echo 'Java $(java -version) installation finished!'",
  "echo 'Proceeding with installing jenkins...'",

  <<EOF
  sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
  echo 'deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]' \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
  EOF
  ,
  "sudo apt-get update",
  "sudo apt-get install jenkins -y",
  "sudo systemctl enable jenkins",
  "sudo systemctl start jenkins",

  "echo 'Jenkins server installed! Now installing certbot...",
  "sudo apt install certbot -y",

  "echo 'Certbot installed! Now please issue a certificate...'",
  # echo <<EOF
  # sudo certbot certonly --standalone --agree-tos -m iliyan.kostov@email.ikostov.org -d jenkins.ikostov.org
  # cd /etc/letsencrypt/live/jenkins.ikostov.org/
  # openssl pkcs12 -inkey privkey.pem -in cert.pem -export -out keys.pkcs12
  # keytool -importkeystore -srckeystore keys.pkcs12 -srcstoretype pkcs12 -destkeystore /var/lib/jenkins/jenkins.jks
  #
  # # Maybe change this ? Not sure
  # vim /etc/default/jenkins
  # JENKINS_ARGS="--webroot=/var/cache/$NAME/war --httpPort=1 --httpsPort=443 --httpsKeyStore=/var/lib/jenkins/jenkins.jks --httpsKeyStorePassword=<input password from previous command>"
  #
  # vim /usr/lib/systemd/system/jenkins.service
  # # Now change the value of ExecPath with:
  # ExecStart=/usr/bin/java -Djava.awt.headless=true -jar /usr/share/java/jenkins.war --webroot=/var/cache/jenkins/war --httpPort=-1 --httpsPort=443 --httpsKeyStore=/var/lib/jenkins/jenkins.jks --httpsKeyStorePassword=<input password from previous command>
  #
  # # Now Give permissions for the java to use port 443
  # sudo setcap 'cap_net_bind_service=+ep' $(readlink -f /usr/bin/java)
  # sudo getcap $(readlink -f /usr/bin/java)
  # sudo systemctl daemon-reload
  # sudo systemctl restart jenkins
  # EOF
]

ec2_default = {
  type = "t2.micro"
  ami = {
    most_recent = true
    owners      = ["amazon"]
    images      = ["amzn3-ami-hvm-*"]
  }
}
