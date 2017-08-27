class Server < EventMachine::Connection

  @@options = {}

  def self.options
    @@options
  end

  def self.options=(opts)
    @@options = opts
  end

  def initialize(input, output, server_close, client_close)
    super
    @input  = input
    @output = output
    @server_close = server_close
    @client_close = client_close

    @input_sid        = @input.subscribe        { |msg| send_data msg }
    @client_close_sid = @client_close.subscribe { |msg| close_connection }
  end

  def post_init
    start_tls if Server.options[:use_tls_remote]
  end

  def receive_data(data)
    @output.push data
  end

  def unbind
    @server_close.push "exit"
    @input.unsubscribe        @input_sid
    @client_close.unsubscribe @client_close_sid
  end

end
