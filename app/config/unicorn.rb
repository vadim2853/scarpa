app_dir = '/var/www/scarpa/current'

working_directory app_dir

pid '/tmp/unicorn.pid'

stderr_path "#{app_dir}/log/unicorn.stderr.log"
stdout_path "#{app_dir}/log/unicorn.stdout.log"

worker_processes 1
listen '/tmp/unicorn.sock', backlog: 64
timeout 30
