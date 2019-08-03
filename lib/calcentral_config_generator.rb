require_relative './calcentral_config_generator/calcentral_config'
require_relative './calcentral_config_generator/parser'

class CalCentralConfigGenerator
  attr_reader :options

  def initialize(args = %w[])
    @options = Parser.parse(args)
  end

  def call
    if options.output_file
      File.open(File.expand_path(options.output_file), "w") do |file|
        file.write(config.to_yaml)
      end

      puts "Config output to: #{options.output_file}"
    else
      puts config.to_yaml
    end

    if options.tunnel
      File.open(File.expand_path(options.ssh_config_file), "w") do |file|
        file.write(config.to_ssh)
      end

      puts "SSH config output to: #{options.ssh_config_file}"
    end
  end

  def config
    @config ||= CalCentralConfig.new({
      config_file:    options.config_file,
      config_dir:     options.config_dir,
      starting_port:  options.starting_port,
      tunnel:         options.tunnel,
      ssh_user:       options.ssh_user,
      default_env:    options.default_env
    })
  end
end
