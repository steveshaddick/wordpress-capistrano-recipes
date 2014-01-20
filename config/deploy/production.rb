set :current_environment, "production"
set :branch, "master"

set :domain, "[PRODUCTION DOMAIN]"

set :user, "[SSH USER]"
set :password, "[SSH PASSWORD]"

set :dbpass, "[DB PASSWORD]"
set :dbuser, "[DB USER]"
set :dbname, "[DB NAME]"
set :dbhost, "[DB HOST]"

set :staging_uploads_path, "[ABSOLUTE PATH TO WP UPLOADS ON STAGING]"


##########
# DEFAULTS
##########
set :url, "http://#{domain}"
set :deploy_to, "/home/#{user}/domains/#{domain}"
set :current_release, "#{deploy_to}/current"

set(:wordpress_uploads_path) { File.join(shared_path, "/uploads") }
set :wordpress_local_uploads_path, "#{local_path}/tmp/shared/uploads"
set :wordpress_wpcontent, "#{current_release}/public/wp-content"
set :wordpress_shared_folders, [
  ["#{wordpress_uploads_path}", "#{wordpress_wpcontent}/uploads"],
  ["#{shared_path}/cache", "#{wordpress_wpcontent}/cache"],
]

set :environment_config_path, "#{current_release}/config/environments/#{current_environment}"
set :site_root_path, "#{current_release}/public"

set :port, 22
server domain, :app, :web
role :db, domain, :primary => true