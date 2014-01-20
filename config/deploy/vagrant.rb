set :current_environment, "vagrant"

set :dbhost, "localhost"
set :dbuser, "vagrant"
set :dbpass, "vagrant"
set :dbname, "vagrant"

set :user, "vagrant"


##########
# DEFAULTS
##########

server "127.0.0.1", :app, :web, :db, :primary => true
set :deploy_to, "/home/#{user}/current"
set :current_release, deploy_to
set :shared_path, "#{deploy_to}/tmp/shared"
set :site_root_path, "#{current_release}/public"
set :environment_config_path, "#{current_release}/config/environments/#{current_environment}"

#wordpress
set :wordpress_uploads_path, "/project/tmp/shared/uploads"
set :wordpress_local_uploads_path, "#{local_path}/tmp/shared/uploads"
set :wordpress_wpcontent, "#{current_release}/public/wp-content"
set :wordpress_shared_folders, [
  ["#{wordpress_uploads_path}", "#{wordpress_wpcontent}/uploads"],
  ["#{shared_path}/cache", "#{wordpress_wpcontent}/cache"],
]

#vagrant
set :local_user, `whoami`.delete("\n")
set :domain, "#{short_name}-" + local_user + ".local"

set (:vagrant_port) do
  port = 2222
  ssh_config=`vagrant ssh-config`.split("\n  ") ;  result=$?.success?
  abort "Calling vagrant ssh-config failed." unless result
  ssh_config.each do |i|
   k,v = i.split(" ")
   if k == "Port"
     port = v
   end
  end
  port
end
ssh_options[:keys] = ['~/.vagrant.d/insecure_private_key']
ssh_options[:port] = vagrant_port
