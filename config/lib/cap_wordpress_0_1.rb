namespace:wordpress do
  
  task:link_shared_folders do
    #symlink any shared folders worpress uses
    wordpress_shared_folders.each do |folder|
      symlink_dir(folder[0], folder[1])
    end
  end

  task:put_environment do
    run "cp -rf #{environment_config_path}/wp-config.php #{site_root_path}/wp-config.php"
    if current_environment == 'vagrant' then
      run "perl -pi -e 's/&&_LOCAL_USER_&&/#{local_user}/g' #{site_root_path}/wp-config.php"
    end

    if remote_file_exists?("#{environment_config_path}/robots.txt")
      run "cp -rf #{environment_config_path}/robots.txt #{site_root_path}/robots.txt"
    end
  end

  task:finalize_update do
    link_shared_folders
    put_environment
  end

  task:flush_rules do
    run <<-CMD
        curl #{url}/wp-login.php > /dev/null
    CMD
  end

  task:tar_uploads do
    run "mkdir -p #{deploy_to}/tmp"
    run "rm -rf #{deploy_to}/tmp/uploads.tar.gz"
    run "cd #{wordpress_uploads_path} && tar -czf #{deploy_to}/tmp/uploads.tar.gz ."
    if current_environment != "vagrant"
      download("#{deploy_to}/tmp/uploads.tar.gz","#{local_path}/tmp/uploads.tar.gz")
    end
  end

  task:put_uploads do 
    puts "This can take a long while ..."
    run_locally "rsync -avrz --progress #{wordpress_local_uploads_path}/ #{user}@#{domain}:#{wordpress_uploads_path}/"
  end

  task:sync_uploads do 
    if current_environment == 'production' then
      run "rsync -avruW --progress #{staging_uploads_path}/ #{wordpress_uploads_path}/"
    elsif current_environment == 'staging' then
      run "rsync -avrW --progress --delete #{production_uploads_path}/ #{wordpress_uploads_path}/"
    else
      puts "Sync FAILED: You can only sync production & staging files. Use put_uploads or get_uploads instead."
    end
  end

  task:get_uploads do 
    puts "This can take a long while ..."
    run_locally "rsync -avrz --progress #{user}@#{domain}:#{wordpress_uploads_path}/ #{wordpress_local_uploads_path}/"
  end

end