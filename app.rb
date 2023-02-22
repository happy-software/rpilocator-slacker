require 'dotenv/load'
require_relative 'rpilocator_parser'
require_relative 'slack_notifier'

class App
  def run
    available_pis = RpilocatorParser.new.get_available
    available_pis =  [{"update_t"=>{"sort"=>2, "display"=>"2 min."},
                      "price"=>{"sort"=>75, "display"=>"75.00", "currency"=>"USD"},
                      "vendor"=>"Chicago Elec. Dist. (US)",
                      "sku"=>"RPI4-MODBP-8GB",
                      "avail"=>"No",
                      "link"=>"https://chicagodist.com/products/raspberry-pi-4-model-b-8gb",
                      "last_stock"=>{"sort"=>"", "display"=>""},
                      "description"=>"RPi 4 Model B - 8GB RAM"},
      {"update_t"=>{"sort"=>0, "display"=>"0 min."},
       "price"=>{"sort"=>75, "display"=>"75.00", "currency"=>"USD"},
       "vendor"=>"Pishop (US)",
       "sku"=>"RPI4-MODBP-8GB",
       "avail"=>"No",
       "link"=>"https://www.pishop.us/product/raspberry-pi-4-model-b-8gb/",
       "last_stock"=>{"sort"=>"", "display"=>""},
       "description"=>"RPi 4 Model B - 8GB RAM"}]
    if available_pis.any?
      message = format_message(available_pis)
      SlackNotifier.new.post_message(message, ENV['NOTIFICATION_CHANNEL'])
    end
  end

  def format_message(available_pis)
    message = "Found some Raspberry Pis!\n"
    message += available_pis.map do |pi_data|
      "#{pi_data.fetch("sku")} - $#{pi_data.fetch("price").fetch("display")} - #{pi_data.fetch("link")}"
    end.join("\n")
    message += "\nGet them while they last!"
  end
end