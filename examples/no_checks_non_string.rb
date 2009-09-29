require 'exemplor'

class MyClass
  def inspect
    "<MyClass instance>"
  end
end

Examples 'MyClass' do

  eg 'non-string return values get inspected' do
    MyClass.new
  end

end

__END__

MyClass - non-string return values get inspected: 
  ok: <MyClass instance>