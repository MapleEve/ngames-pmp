threads 8,32
# 有几个内核就写几个worker
workers 2
# 后端的运行环境, 不要随便改
environment 'production'
# PID文件的绝对路径
pidfile '/data/pms.pid'
# state文件的绝对路径
state_path '/data/pms.state'
# 后台执行
daemonize true
# puma日志的绝对路径
stdout_redirect "/data/puma.stdout.log", "/data/puma.stderr.log"
# 给前端反向代理的soket文件绝对路径
bind 'unix:/data/pms.sock'
#bind 'tcp://0.0.0.0:3333'

preload_app!

# 初始化数据库连接用
on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end