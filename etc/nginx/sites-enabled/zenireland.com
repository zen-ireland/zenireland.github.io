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
    root /home/zen/zenireland/_site;

    #location /jekyll {
    #    alias /home/zen/zenireland.jekyll/_site;
    #}

    location ~* \.(?:jpg|jpeg|gif|png|ico|cur|gz|svg|svgz|mp4|ogg|ogv|webm|htc)$ {
      expires 1M;
      add_header Cache-Control "public";
    }

    location ~* \.(?:css|js)$ {
      expires 1h;
      add_header Cache-Control "public";
    }

    #location /admin {
    #    proxy_pass http://127.0.0.1:4000/admin;
    #
    #    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    #    proxy_set_header X-Forwarded-Proto $scheme;
    #    proxy_set_header X-Real-IP $remote_addr;
    #    proxy_set_header Host $http_host;

    #    #proxy_max_temp_file_size 0;
    #    proxy_buffering on;
    #    proxy_buffers 16 16k;
    #    proxy_buffer_size 16k;
    #}
}
