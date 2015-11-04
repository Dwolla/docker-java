require 'rake'
require 'rspec/core/rake_task'

SHORT_IMAGE_NAME = "dwolla/java"
IMAGE_VERSION = "8"
IMAGE_NAME = "#{SHORT_IMAGE_NAME}:#{IMAGE_VERSION}"

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

desc "Publish to GitHub, where the automated Docker build will take place"
task :publish => :spec do
  sh "if ! (git remote | fgrep github > /dev/null); then git remote add github git@github.com:Dwolla/docker-java.git; fi && \
      git push github HEAD:master"
end

desc "Clean up artifacts and local Docker images"
task :clean do
  if images.length > 0
    sh "docker rmi -f #{images}"
  end
end

def images
  `docker images | fgrep #{SHORT_IMAGE_NAME} | awk '{if ($2 == #{IMAGE_VERSION}) print $3}' | awk ' !x[$0]++' | paste -sd ' ' -`
end
