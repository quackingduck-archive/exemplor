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

- name: Non-string return values get converted to yaml
  status: info (no checks)
  result: !ruby/object:MyClass 
    foo: bar
