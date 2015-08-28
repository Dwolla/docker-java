require 'rake'
require 'rspec/core/rake_task'

DOCKER_REPOSITORY = ENV["DOCKER_REPOSITORY"] || "docker.sandbox.dwolla.net" 
SHORT_IMAGE_NAME = "dwolla/java"
IMAGE_VERSION = "8"
IMAGE_NAME_WOUT_VERSION = "#{DOCKER_REPOSITORY}/#{SHORT_IMAGE_NAME}"
IMAGE_NAME = "#{IMAGE_NAME_WOUT_VERSION}:#{IMAGE_VERSION}"

desc "Default task: Build Docker image, run tests"
task :default => :spec

desc "Run tests"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob('spec/**/*_spec.rb')
end

task :spec => :build

desc "Build the Docker Image"
task :build do
  sh "docker build --tag #{IMAGE_NAME} ."
end

desc "Push Docker image to repository"
task :publish => :spec do
  sh "docker push #{IMAGE_NAME}"
end

desc "Clean up artifacts and local Docker images"
task :clean do
  if images.length > 0
    sh "docker rmi -f #{images}"
  end
end

def images
  `docker images | fgrep #{IMAGE_NAME_WOUT_VERSION} | awk '{if ($2 == #{IMAGE_VERSION}) print $3}' | awk ' !x[$0]++' | paste -sd ' ' -`
end
