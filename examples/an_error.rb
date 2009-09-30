require 'exemplor'

eg 'Raising an error' do
  raise "boom!"    
end

__END__

(e) Raising an error: 
  class: RuntimeError
  message: boom!
  backtrace: 
  - examples/an_error.rb:4
  # ... more backtrace lines