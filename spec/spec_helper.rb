require "rubygems"
require "rspec"

# Add the 'spec' path in the load path
spec_dir = File.dirname(__FILE__)
$LOAD_PATH.unshift(spec_dir)

Dir[File.join(spec_dir, "../*.rb")].each {|f| require f}



