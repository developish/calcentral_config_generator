require 'yaml'
require 'erb'

require_relative './edo_db_configs'

class CalCentralConfig
  def initialize(tunnel:, config_file: nil, config_dir:, starting_port:, ssh_user:, default_env:)
    @config_file = config_file
    @tunnel = tunnel
    @starting_port = starting_port
    @config_dir = config_dir
    @ssh_user = ssh_user
    @default_env = default_env
  end

  def to_yaml
    to_h.to_yaml
  end

  def to_ssh
    ERB.new(ssh_template, nil, "%<>").result_with_hash({
      forwards: edodb.ssh_forwards,
      user: @ssh_user
    })
  end

  def next_port
    if @current_port
      @current_port = @current_port + 1
    else
      @current_port = @starting_port
    end

    return @current_port
  end

  def tunnel?
    @tunnel
  end

  private

  def env_for(key)
    input_config.fetch(key) { @default_env }
  end

  def input_config
    @input_config ||= if @config_file
                        YAML.load(File.open(File.expand_path(@config_file)))
                      else
                        {}
                      end
  end

  def ssh_template
    File.open(File.expand_path(__dir__ + "/ssh_template.erb")).read
  end

  def load(filename)
    filename = File.expand_path("#{@config_dir}/#{filename}")
    file = File.open(filename)
    YAML.load(file)
  end

  def env_from_file(key, filename=nil)
    filename ||= "#{key}.yml"
    load(filename)[env_for(key)]
  rescue Errno::ENOENT
    nil
  end

  def to_h
    @config ||= Hash.new.tap do |config|
      cas_config = env_from_file("cas")
      config.merge!(cas_config) unless cas_config.nil?

      config["edodb"] = edodb.to_h[env_for('edodb')]

      files = Dir[File.expand_path(@config_dir + "/*.yml")]
      files.each do |file|
        name = File.basename(file, ".yml")
        unless %w[cas edodb].include?(name)
          set_config_if_present(config, name, name)
        end
      end
    end
  end

  def set_config_if_present(config, key, filename)
    configuration = env_from_file(filename)
    config[key] = configuration if configuration
  end

  def edodb
    @edodb ||= EdoDBConfigs.new(self, load("edo_db.yml"))
  end
end
