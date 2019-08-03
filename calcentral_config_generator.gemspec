Gem::Specification.new do |s|
  s.name = "calcentral_config_generator"
  s.version = "0.0.0"
  s.date = "2019-08-01"
  s.summary = "CalCentral Config Generator"
  s.description = "Configuration generator for calcentral.berkeley.edu"
  s.authors = ["Brandon Wright"]
  s.email = ["brandon@developish.com"]
  s.files = [
    "lib/calcentral_config_generator.rb",
    "lib/calcentral_config_generator/calcentral_config.rb",
    "lib/calcentral_config_generator/edo_db_configs.rb",
    "lib/calcentral_config_generator/edo_db_environment.rb",
    "lib/calcentral_config_generator/parser.rb",
    "lib/calcentral_config_generator/ssh_template.erb"
  ]
  s.homepage = "https://github.com/developish/calcentral_config_generator"
  s.license = "0BSD"
  s.executables << 'calcentral-config-generator'
end
