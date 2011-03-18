##########################################################
# mimiuchi
##########################################################
set :application, "savedenki"
set :domain, "savedenki.info"
set :rails_env, :production

set :deploy_to, "/home/okitsu/www/#{application}"

default_run_options[:pty] = true  # Must be set for the password prompt from git to work
set :repository, "git@github.com:okitsutakatomo/savedenki.git"
set :scm, :git
set :use_sudo, false
set :user, "okitsu"
ssh_options[:forward_agent] = true
set :branch, "master"
#set :deploy_via, :remote_cache
#set :scm_passphrase, "p@ssw0rd"  # The deploy user's password

# USER
#set :user do Capistrano::CLI.ui.ask('SSH User: ') end
#set :password do Capistrano::CLI.password_prompt('SSH Password: ') end

role :web, domain
role :app, domain
role :db, domain, :primary => true

puts "************************************************"
puts "*** Deploying to #{domain} (#{application}/#{rails_env}) " 
puts "************************************************"

after "deploy:restart", "restart_twitterstream"

desc "Restart TwitterStreamWorker"
task :restart_twitterstream do
  run "ruby #{current_path}/script/twitterstream.rb stop #{rails_env}"
  run "ruby #{current_path}/script/twitterstream.rb start #{rails_env}"
end

#バックアップする
#before "deploy:migrate", "backup:mysql"

namespace :deploy do
  task :restart, :roles => :app do
    send(:run, "touch #{current_path}/tmp/restart.txt")
  end
  
  task :start, :roles => :app do
    send(run_method, "sudo /etc/init.d/httpd restart")
  end
end


# MySQLバックアップ用
namespace :backup do
  desc "Backup remote production DB with mysqldump"
  task :mysql, :roles => :db, :only => { :primary => true } do
    require 'yaml'
    require 'fileutils'
    
    backup_dir_path = "#{shared_path}/db_backup"
    filename = "#{application}.#{Time.now.strftime("%Y-%m-%d_%H-%M-%S")}.sql.bz2"
    file = "#{backup_dir_path}/#{filename}"

    # フォルダ作成
    FileUtils.mkdir_p backup_dir_path unless File.exists?(backup_dir_path)

    # transaction中でエラーが発生すると、以下の処理を行う
    on_rollback { delete file }

    # DBの設定読み込み
    db = YAML::load(ERB.new(IO.read(File.join(File.dirname(__FILE__), '../database.yml'))).result)['production']

    # MYSQL dump
    run "mysqldump -u #{db['username']} --password=#{db['password']} #{db['database']} | bzip2 -c > #{file}"  do |ch, stream, data|
       puts data
    end
  end
end

