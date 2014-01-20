namespace:database do
  task:get do
    run "mkdir -p #{deploy_to}/tmp" 
    run <<-CMD
       mysqldump #{dbname} -u#{dbuser} --host=#{dbhost} --password=#{dbpass} > #{deploy_to}/tmp/db.sql
    CMD
    if current_environment != "vagrant"
      download("#{deploy_to}/tmp/db.sql","#{local_path}/tmp/db.sql",:via => :scp)
    end
  end

  task:backup do
    run "mkdir -p #{deploy_to}/tmp" 
    run <<-CMD
       mysqldump #{dbname} -u#{dbuser} --host=#{dbhost} --password=#{dbpass} > #{deploy_to}/tmp/db.sql
    CMD
    run_locally "mkdir -p #{local_path}/data" 
    download("#{deploy_to}/tmp/db.sql","#{local_path}/data/db_#{current_environment}_" + Time.now.strftime("%Y_%m_%d_%H_%M") + ".sql",:via => :scp)
  end

  task:put do
    if current_environment == "vagrant"
      run "mysql -u#{dbuser} --password=#{dbpass} --host=#{dbhost}  #{dbname} < #{deploy_to}/tmp/db.sql"
    
    else
      database.backup
      if !remote_dir_exists?("#{deploy_to}/tmp")
       run "mkdir #{deploy_to}/tmp" 
      end
      upload("#{local_path}/tmp/db.sql","#{deploy_to}/tmp/db.sql",:via => :scp)
      run <<-CMD
         mysql -u#{dbuser} --password=#{dbpass} --host=#{dbhost}  #{dbname} < #{deploy_to}/tmp/db.sql
      CMD
      if current_environment != "vagrant"
        run "rm -f #{deploy_to}/tmp/db.sql"
      end 
    
    end
  end
end