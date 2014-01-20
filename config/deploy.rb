require 'capistrano/ext/multistage'
Dir[File.expand_path(File.dirname(__FILE__)) + "/lib/*"].each {|file| load file }

set :stages, %w(staging production vagrant)

set :application, "[APP NAME]"
set :short_name, "[APP SHORT NAME]"
set :repository, "[REPO]"

##########
# DEFAULTS
##########

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, false
set :scm, :git
set :deploy_via, :remote_cache
set :local_path, File.expand_path(File.dirname(__FILE__) + '/../')


#############################################################
#   Task Flow
#############################################################
before "deploy:update", 'environment:disallow_vagrant'
before "deploy:setup", 'environment:disallow_vagrant'

after "deploy:create_symlink", "wordpress:finalize_update"


#############################################################
#   Tasks
#############################################################

namespace:deploy do
  task:start do
    # do nothing
  end

  task:stop do
    # do nothing
  end

  task:restart do
    #do nothing
  end

  task:post_deploy do
    #add any tasks in here that you want to run after the project is deployed
  end
end
