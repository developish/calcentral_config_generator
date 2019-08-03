desc "Clean, build, install"
task :clean_build => [
  :build, :install, :clean
]

desc "Install the build gem"
task :install do
  puts "installing calcentral_config_generator"
  `gem install calcentral_config_generator-0.0.0.gem`
end

desc "Cleanup the gem"
task :clean do
  puts "cleaning calcentral_config_generator-0.0.0.gem"
  `rm calcentral_config_generator-0.0.0.gem`
end

desc "Build the gem"
task :build do
  puts "building calcentral_config_generator-0.0.0.gem from gemspec"
  `gem build calcentral_config_generator.gemspec`
end
