require 'cinch'
require 'dotenv'
require 'open-uri'
require 'nokogiri'
require 'cgi'

Dotenv.load

bot = Cinch::Bot.new do
  configure do |c|
    c.nick = 'benevolent_bot'
    c.password = ENV['PASSWORD']
    c.server = "irc.freenode.org"
    c.channels = ["#chicago-oss-devs"]
    c.verbose = true
  end

  on :join do |m|
    unless m.user.nick == bot.nick # We shouldn't attempt to voice ourselves
      m.channel.voice(m.user) if @autovoice
    end
  end

  on :channel, /^!autovoice (on|off)$/ do |m, option|
    @autovoice = option == "on"

    m.reply "<< Autovoice >> is now #{@autovoice ? 'enabled' : 'disabled'}"
  end

  on :message, "hello" do |m|
    m.reply "<<Hello, #{m.user.nick}>> Welcome to #chicago-oss-devs! I am a bot. Type help."
  end

  on :message, "!help" do |m|
    m.reply "<<Help>> I have many commands. Type !help to see this, !newbie for a new user's guide, !urban something to search urban dictionary"
  end

  on :message, "!newbie" do |m|
    m.reply "<<Newbie>> Visit https://github.com/chicago-oss-devs/chat-channel"
  end

  helpers do
    # This method assumes everything will go ok, it's not the best method
    # of doing this *by far* and is simply a helper method to show how it
    # can be done.. it works!
    def urban_dict(query)
      url = "http://www.urbandictionary.com/define.php?term=#{CGI.escape(query)}"
      CGI.unescape_html Nokogiri::HTML(open(url)).at("div.definition").text.gsub(/\s+/, ' ') rescue nil
    end
  end

  on :message, /^!urban (.+)/ do |m, term|
    m.reply(urban_dict(term) || "No results found", true)
  end


end

bot.start
