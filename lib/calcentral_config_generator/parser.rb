require "optparse"
require "ostruct"

class Parser
  def self.parse(args)
    options = OpenStruct.new

    # Default arguments
    options.tunnel = false
    options.output_file = false
    options.starting_port = 3333
    options.config_dir = "~/.calcentral_config/yml"
    options.ssh_user = "username"
    options.default_env = "dev"

    parser = OptionParser.new do |opt_parser|
      opt_parser.banner = "Usage calcentral-config-generator [options]"

      opt_parser.on("-c=CONFIG_FILE", "--config=CONFIG_FILE") do |config_file|
        options.config_file = config_file
      end

      opt_parser.on("-e=DEFAULT_ENV", "--env=DEFAULT_ENV") do |default_env|
        options.default_env = default_env
      end

      opt_parser.on("-t", "--tunnel[=TUNNEL_PORT]", "Configure for SSH tunneling to databases") do |starting_port|
        options.tunnel = true
        options.starting_port = starting_port || 3333
        options.ssh_config_file = "./dbtunnel_config"
      end

      opt_parser.on("-o", "--output[=OUTPUT_FILE]", "Sets an output file for the config file (default: development.local.yml") do |output_file|
        options.output_file = output_file || "./development.local.yml"
      end

      opt_parser.on("--ssh-config=SSH_CONFIG_FILE", "Output SSH tunnel file") do |ssh_config_file|
        options.ssh_config_file = ssh_config_file
      end

      opt_parser.on("--user=USERNAME", "Specify SSH username") do |username|
        options.ssh_user = username
      end

      opt_parser.on("-d=CONFIG_DIR", "--config-dir=CONFIG_DIR", "Set config dir") do |config_dir|
        options.config_dir = config_dir
      end

      opt_parser.on("-h", "--help", "Prints this help") do
        puts opt_parser
        exit
      end
    end

    parser.parse!(args)

    return options
  end
end
