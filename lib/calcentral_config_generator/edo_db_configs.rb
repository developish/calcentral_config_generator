require_relative "./edo_db_environment"

class EdoDBConfigs
  def initialize(config, yaml)
    @config = config
    @yaml = yaml
  end

  def all
    return @all if defined? @all

    @all = Array.new.tap do |configs|
      @yaml.reject do |key, value|
        key == "defaults"
      end.each do |key, value|
        configs << EdoDBEnvironment.new(key, @config, value)
      end
    end
  end

  def to_h
    Hash.new.tap do |hash|
      all.each do |config|
        hash[config.env] = config.to_h
      end
    end
  end

  def ssh_forwards
    all.map do |config|
      config.ssh_forward
    end
  end
end
