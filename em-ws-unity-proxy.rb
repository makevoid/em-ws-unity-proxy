require_relative "env"

config = YAML.load File.read "#{App.path}/config.yml"

# script/app/route configs

LOG_ON = false

# OP_MAIN = PING
OP_MAIN = UTX

MESSAGES = []

STATE = {
  timer: nil,
}


puts "Server will start on:\n\n  ws://0.0.0.0:8080 - please point your unity server configuration to this address/port.\n\n"

EM.run do

  # client - to blockchain.info ws
  EM.run do
    wsUrl = "wss://ws.blockchain.info/inv"

    conn = EventMachine::WebSocketClient.connect wsUrl

    conn.callback do
      conn.send_msg Oj.dump(OP_MAIN, mode: :compat)
    end

    conn.errback do |e|
      puts "Got error: #{e}"
    end

    conn.stream do |msg|
      puts "message received: #{msg.inspect}"
      MESSAGES.push msg

      File.open("#{PATH}/log/ws.log", "a"){ |f| f.write "#{msg}\n"  } if LOG_ON

      MESSAGES.pop if MESSAGES.size > 50
      #conn.close_connection if msg.data == "done"
    end
  end

  # server - passes new txs to unity
  EM.run do
    WebSocket::EventMachine::Server.start(host: "0.0.0.0", port: 8080) do |ws|

      # # client connection onmessage
      # conn.stream do |msg|
      #   puts "message received: #{msg.inspect}"
      #   conn.close_connection if msg.data == "done"
      #
      #   # ws.send msg, type: :text
      #
      # end

      ws.onopen do
        puts "Client connected"

        EM.defer do
          STATE[:timer] = EventMachine::PeriodicTimer.new(0.1) do
            MESSAGES.size.times do
              msg = MESSAGES.pop

              # forwards message to the client (unity)
              ws.send msg.data, type: :text
            end
          end
        end
      end

      # NOT NEEDED
      ws.onmessage do |msg, type|
        puts "Received message: #{msg}"
        # hash = { test: "true123" }
        # msg  = Oj.dump hash
        # ws.send msg, type: :text
      end

      ws.onclose do
        puts "Client disconnected"
        STATE[:timer].cancel
      end

    end

  end

end
