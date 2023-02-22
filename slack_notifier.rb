require 'slack'

class SlackNotifier
  def initialize
    Slack.configure do |c|
      c.token = ENV['SLACK_API_KEY']
    end
  end

  def post_message(message, channel)
    params = {
      text: message,
      channel: channel,
      icon_emoji: random_emoji,
    }
    slack = Slack::Web::Client.new
    slack.chat_postMessage(params)
  end

  def random_emoji
    emoji = [
      :ayylmao, :ayy_lmao, :bruh, :ceilingcat, :chef, :clapping, :dab2, :dabmas, :dude_suh, :elon, :erbefe2,
      :fidget_spinner, :gran, :italian_kissy_fingers, :kappa, :lolwut, :mother_of_god, :okaychamp,
      :shaka, :slippin, :squiddab, :suh_dude, :teamwork, :vapeweedeveryday, :vegeta, :vegeta9000, :spidernice,
      :goodjobdesu, :word, :sniff, :"fb-wow", :lfg, :lfg2, :lfg3, :pugdance, :vibe, :letsgo, :catjam, :dancing_dog
    ].sample

    ":#{emoji}:"
  end
end