require_relative "env"

config = YAML.load File.read "#{App.path}/config.yml"

EM.run do
  wsUrl = "ws://#{config[:local_host]}:#{config[:local_port]}"
  # wsUrl = "wss://ws.blockchain.info/inv"

  conn = EventMachine::WebSocketClient.connect wsUrl

  conn.callback do
    conn.send_msg Oj.dump(PING_I, mode: :compat)
  end

  conn.errback do |e|
    puts "Got error: #{e}"
  end

  conn.stream do |msg|
    puts "message received: #{msg.inspect}"
    #conn.close_connection if msg.data == "done"
  end

end
