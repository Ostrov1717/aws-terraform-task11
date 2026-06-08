dnf update -y
dnf install -y httpd jq

systemctl start httpd
systemctl enable httpd

echo "<h1>${color} Environment</h1>" > /var/www/html/index.html