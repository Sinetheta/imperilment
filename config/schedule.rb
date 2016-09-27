env :PATH, ENV['PATH']
set :output, 'log/cron_log.log'

every :weekday, at: '10am' do
  rake "notify_slack:post_answers"
end
