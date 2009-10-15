require 'exemplor'

class MyClass
  def initialize
    @foo = "bar"
  end
end

eg 'Non-string return values get converted to yaml' do
  MyClass.new
end

__END__

(i) Non-string return values get converted to yaml: !ruby/object:MyClass 
  foo: bar