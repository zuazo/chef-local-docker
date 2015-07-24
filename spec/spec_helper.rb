require 'should_not/rspec'
require 'docker'

Docker.options[:read_timeout] = 50 * 60 # 50 mins

# Module responsible for the creation and destruction of the docker image.
module DockerContext
  extend RSpec::SharedContext

  # DockerContext constructor.
  def initialize(*args)
    super
    ObjectSpace.define_finalizer(self, proc { cleanup_image })
  end

  def dockerfile_location
    ENV['DOCKERFILE_LOCATION'] || 'debian-7'
  end

  # Dockerfile directory path.
  def dockerfile_dir
    root = File.join(File.dirname(__FILE__), '..')
    dockerfile_location.nil? ? root : File.join(root, dockerfile_location)
  end

  # Returns the Docker::Image instance built from the Dockerfile.
  def image
    @image ||= Docker::Image.build_from_dir(dockerfile_dir)
  end

  # Removes the temporary docker image used to run the tests.
  def cleanup_image
    return if @image.nil?
    @image.remove(force: true)
    @image = nil
  end

  # Helper to get the docker image configuration hash easily.
  let(:image_config) { image.json['Config'] }
end

RSpec.configure do |config|
  # Prohibit using the should syntax
  config.expect_with :rspec do |spec|
    spec.syntax = :expect
  end

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  # --seed 1234
  config.order = 'random'

  config.color = true
  config.formatter = :documentation
  config.tty = true

  config.include DockerContext
end
