require "serverspec"
require "docker"
require "multi_json"

DOCKER_IMAGE_TAG = 'jenkins-linux.dwolla.net/dwolla/java:8'

describe "docker.dwolla.com/dwolla/java:8" do
  it "sets DNS TTL to 60" do
    expect(java_security).to include("networkaddress.cache.ttl=60")
  end

  it "includes Java 8" do
    expect(java_version).to include("1.8")
  end

  it "is maintained by Dwolla Dev" do
    expect(image_inspection['Author']).to eq 'Dwolla Engineering <dev+docker@dwolla.com>'
  end

  it "contains the Dockerfile at /Dockerfile" do
    expect(file("/Dockerfile").content).to eq File.read("Dockerfile")
  end

  before(:all) do
    image = Docker::Image.build_from_dir('.', {
      't' => DOCKER_IMAGE_TAG
    })

    set :os, family: :debian
    set :backend, :docker
    set :docker_image, image.id

    @image = image
  end

  def os_version
    command("cat /etc/os-release").stdout
  end

  def java_security
    command("cat $(dirname $(dirname `realpath /etc/alternatives/java`))/lib/security/java.security").stdout
  end

  def java_version
    command("java -version").stderr
  end

  def image_inspection
    ::MultiJson.load(`docker inspect #{@image.id}`)[0]
  end
end

