# redirect zenireland.com to https://www.zenireland.com
server {
    server_name zenireland.com;
    return 302 http://www.zenireland.com$request_uri;

    listen [::]:443 ssl; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/mlaheenarchitects.ie/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/mlaheenarchitects.ie/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
}

server {
    server_name www.zenireland.com;
    root /home/zen/zenireland/_site;

    listen [::]:443 ssl; # managed by Certbot
    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/mlaheenarchitects.ie/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/mlaheenarchitects.ie/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

    location ~ ^/(admin|_api)(/.*)? {
      auth_basic_user_file /home/zen/zenireland/etc/nginx/sites-enabled/htpasswd;
      auth_basic "Administration";

      proxy_pass http://127.0.0.1:4000/$1$2;

      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header Host $http_host;

      #proxy_max_temp_file_si
      proxy_buffering on;
      proxy_buffers 16 16k;
      proxy_buffer_size 16k;
    }

    location ~* \.(?:jpg|jpeg|gif|png|ico|cur|gz|svg|svgz|mp4|ogg|ogv|webm|htc)$ {
      expires 1M;
      add_header Cache-Control "public";
    }

    location ~* \.(?:css|js)$ {
      expires 1h;
      add_header Cache-Control "public";
    }
}

server {
    if ($host = zenireland.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80;
    listen [::]:80;
    server_name zenireland.com;
    return 404; # managed by Certbot
}

server {
    if ($host = www.zenireland.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80;
    listen [::]:80;

    server_name www.zenireland.com;
    return 404; # managed by Certbot
}
