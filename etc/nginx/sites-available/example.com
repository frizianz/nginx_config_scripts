# Server block to redirect to www.example.com
server {
        listen 80 ;
        listen 443 ssl;
        server_name example.com ;

        access_log /var/log/nginx/example.com-access.log;
        error_log /var/log/nginx/example.com-error.log error;

        root /var/www/root;

        ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
        include /etc/nginx/snippet/ssl.conf;

        include /etc/nginx/snippet/redirect-www.conf;

}

# Server Block with forcing of SSL + Cloudflare
server {
	listen 80 ;
	listen 443 ssl;
	server_name www.example.com ;

	access_log /var/log/nginx/example.com-access.log;
	error_log /var/log/nginx/example.com-error.log error;

        root /mnt/datastore/www/example_com/www/htdocs;

	ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
	include /etc/nginx/snippet/ssl.conf;

        index index.html;

	include /etc/nginx/snippet/redirect-www.conf;
	include /etc/nginx/snippet/letsencrypt.conf;
	include /etc/nginx/snippet/forcessl.conf;
	include /etc/nginx/snippet/cloudflare-fix-ip.conf;
}


# Example Wordpress configuration + Cloudflare
server {
	listen 80 ;
	listen 443 ssl;
	server_name blog.example.com ;

	access_log /var/log/nginx/example.com-access.log;
	error_log /var/log/nginx/example.com-error.log error;

        root /mnt/datastore/www/example_com/blog/htdocs;

	ssl_certificate /etc/letsencrypt/live/blog.example.com/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/blog.example.com/privkey.pem;
	include /etc/nginx/snippet/ssl.conf;

        index index.php;

	include /etc/nginx/snippet/letsencrypt.conf;
	include /etc/nginx/snippet/forcessl.conf;
	include /etc/nginx/snippet/usephp.conf;
	include /etc/nginx/snippet/tryuri_index_wordpress.conf;
	include /etc/nginx/snippet/cloudflare-fix-ip.conf;
}

