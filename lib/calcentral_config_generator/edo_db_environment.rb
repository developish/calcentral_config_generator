class EdoDBEnvironment
  attr_accessor :env

  def initialize(env, config, yaml)
      self.env = env
      @config = config
      @yaml = yaml
      @port = config.next_port if config.tunnel?
  end

  def to_h
      {
      "adapter" => "jdbc",
      "driver" => "oracle.jdbc.OracleDriver",
      "url" => url,
      "password" => @yaml["password"],
      "username" => @yaml["username"]
      }
  end

  def ssh_forward
      "LocalForward #{@yaml["port"]} #{@yaml["url"]}:#{port} # EDO DB - #{env.upcase}"
  end

  def url
      "jdbc:oracle:thin:@#{oracle_host}:#{port}:#{oracle_user}"
  end

  def oracle_host
      @config.tunnel? ? "localhost" : @yaml["url"]
  end

  def port
      @port || @yaml["port"]
  end

  def oracle_user
      @yaml["oracle_user"]
  end
end
