require './apps/torii/app'
require './apps/sampleapp/app'

require 'sprockets'


map '/assets' do
  environment = Sprockets::Environment.new                                   
  environment.append_path 'ui/assets/' 
  run environment
end

use Torii
use SampleApp
run Torii
