namespace :notify_slack do
  desc "Post Answer notifications to Slack for announceable answers"
  task :post_answers => :environment do
    Answer.announceable.each do |ans|
      SlackNotification::NewAnswer.new(ans).deliver
    end
  end
end
