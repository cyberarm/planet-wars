class Network
  class Client
    attr_reader :host, :port, :id, :key, :connection
    include Celluloid::IO

    def initialize(host = GameOverseer::CONFIG[:ip_address], port = GameOverseer::CONFIG[:port], name="captain-#{rand(1000)}")
      @connection= UDPSocket.new
      @host = host
      @port = port
      @id = 0
      @key= 0
      @handshake =false

      @connection.connect(@host, @port)
      send_datagram(Oj.dump({'channel' => 'identity', 'mode' => 'connect', 'username' => "player", 'password' => "secret123"}), @host, @port)
      # send_datagram(Oj.dump({'channel' => 'identity', 'mode' => 'disconnect', 'id' => @id, 'key' => @key}), @host, @port)
    end

    def find_lan_game
    end

    def find_internet_game
    end

    def join_lan_game
    end

    def join_internet_game
    end

    def leave_lan_game
    end

    def leave_internet_game
    end

    def handshake(data)
      if data.kind_of? Hash
        if data['channel'] == 'identity'
          @id = data['id']
          puts @id
          @key= data['key']
          @handshake = true
        end
      end
    end

    def receive_data data
      data = Oj.load(data)
      unless @handshake
        handshake(data)
      end
      puts data
    end
  end
end