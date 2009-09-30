require 'exemplor'

class MyClass
  def inspect
    "<MyClass instance>"
  end
end

eg 'Non-string return values get inspected' do
  MyClass.new
end

__END__

(i) Non-string return values get inspected: <MyClass instance>