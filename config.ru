require './torii/app'
require './sampleapp/app'
=begin
map '/' do
use Torii
use SampleApp#.new
run Torii#.new
end
=end

use Torii
use SampleApp
run Torii

