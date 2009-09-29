require 'exemplor'

Examples do
  
  def foo
    "foo"
  end
  
end

Examples 'Helpers' do

  eg 'with block' do
    foo
  end

end

__END__

Helpers - with block: 
  ok: foo