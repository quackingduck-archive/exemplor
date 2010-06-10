require 'exemplor'
require 'exemplor/rack'

simple_app = lambda { [200,{},'oh hai'] }

eg.app simple_app

eg "rack support works" do
  get '/'
  Assert(last_response.body == 'oh hai')
end