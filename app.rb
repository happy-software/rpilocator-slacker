require 'dotenv/load'
require_relative 'rpilocator_parser'
require_relative 'slack_notifier'

class App
  def run
    available_pis = RpilocatorParser.new.get_available
    if available_pis.any?
      message = format_message(available_pis)
      SlackNotifier.new.post_message(message, ENV['NOTIFICATION_CHANNEL'])
    end
  rescue BadResponse => e
    SlackNotifier.new.post_message(e.message, ENV['NOTIFICATION_CHANNEL'])
  end

  def format_message(available_pis)
    message = "Found some Raspberry Pis!\n"
    message += available_pis.map do |pi_data|
      "#{pi_data.fetch("sku")} - $#{pi_data.fetch("price").fetch("display")} - #{pi_data.fetch("link")}"
    end.join("\n")
    message += "\nGet them while they last!"
  end
end

App.new.run
