require 'exemplor'

Examples 'An Error' do

  eg 'doing something wrong' do
    raise "boom!"    
  end

end

__END__

An Error - doing something wrong: 
  error: 
    class: RuntimeError
    message: boom!
    backtrace: 
    - newsamples/an_error.rb:6
    # ... more backtrace lines