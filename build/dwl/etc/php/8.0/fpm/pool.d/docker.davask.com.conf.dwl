[# PoolName]
user = # UserName
group = www-data
listen = localhost:9000
pm = dynamic
pm.max_children = 20
pm.start_servers = 1
pm.min_spare_servers = 1
pm.max_spare_servers = 5
php_admin_value[upload_tmp_dir] = /home/# UserName/tmp
php_admin_value[session.save_path] = /home/# UserName/tmp