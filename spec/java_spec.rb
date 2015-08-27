require "serverspec"
require "docker"
require "multi_json"

describe "Dockerfile" do
  it "sets DNS TTL to 60" do
    expect(java_security).to include("networkaddress.cache.ttl=60")
  end

  it "includes Java 8" do
    expect(java_version).to include("1.8")
  end

  it "is maintained by Dwolla Dev" do
    expect(image_inspection['Author']).to eq 'Dwolla Engineering <dev+docker@dwolla.com>'
  end

  before(:all) do
    image = Docker::Image.build_from_dir('.', {
      't' => 'docker.sandbox.dwolla.net/dwolla/java:8'
    })

    set :os, family: :debian
    set :backend, :docker
    set :docker_image, image.id

    @image_id = image.id
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
    ::MultiJson.load(`docker inspect #{@image_id}`)[0]
  end
end

