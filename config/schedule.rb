set :output, ""
set :path, "YOUR_BOT_PATH"
set :rbenv_path, "YOUR_RBENV_PATH"

job_type :rbenv_rake, %Q{export PATH=:rbenv_path/shims::rbenv_path/rbenv/bin:/usr/bin:$PATH; eval "$(rbenv init -)"; \
                         cd :path && bundle exec rake :task --silent :output }

every 1.days do
  rbenv_rake 'run'
end