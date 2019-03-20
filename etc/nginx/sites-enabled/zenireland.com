# redirect zenireland.com to https://www.zenireland.com
server {
    listen 80;
    listen [::]:80;
    #listen 443 ssl;
    server_name zenireland.com;
    return 302 http://www.zenireland.com$request_uri;

    #include /etc/nginx/conf.d/zenireland.com.ssl;
}

server {
    listen 80;
    listen [::]:80;

    #server_name 109.74.205.194;
    server_name www.zenireland.com;
    root /home/zen/zenireland/www;
}
