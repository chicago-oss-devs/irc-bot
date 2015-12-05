require 'cinch'
require 'dotenv'

Dotenv.load

bot = Cinch::Bot.new do
  configure do |c|
    c.nick = 'benevolent_bot'
    c.password = ENV['PASSWORD']
    c.server = "irc.freenode.org"
    c.channels = ["#chicago-oss-devs"]
  end

  on :message, "hello" do |m|
    m.reply "<<Hello, #{m.user.nick}>> Welcome to #chicago-oss-devs! I am a bot. Type help."
  end

  on :message, "help" do |m|
    m.reply "<<Help>> I have many commands. Type *help* to see this & *newbie* for a new user's guide."
  end

  on :message, "newbie" do |m|
    m.reply "<<Newbie>> Visit https://github.com/chicago-oss-devs/chat-channel"
  end


end

bot.start
