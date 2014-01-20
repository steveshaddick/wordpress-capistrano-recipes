############################################################
#   Functions
############################################################
def remote_symlink_exists?(full_path)
	'true' == capture("if [ -L #{full_path} ]; then echo 'true'; fi").strip
end

def remote_file_exists?(full_path)
	'true' == capture("if [ -f #{full_path} ]; then echo 'true'; fi").strip
end

def remote_dir_exists?(full_path)
	'true' == capture("if [ -d #{full_path} ]; then echo 'true'; fi").strip
end

def symlink_file(source, target)
  run "rm -f #{target} && ln -s #{source} #{target}"
end

def symlink_dir(source, target)
  run "rm -f #{target} && ln -s #{source} #{target}"
end

namespace:compile do
  task:compass do
    run "compass compile #{current_release} --output-style compressed --force"
  end
end

namespace:environment do
  task:disallow_vagrant do
    if current_environment == 'vagrant'
      error = CommandError.new("Not allowed for vagrant.")
      raise error
    end
  end
end