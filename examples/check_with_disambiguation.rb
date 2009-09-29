require 'exemplor'

Examples 'Array' do

  eg 'appending' do
    list = [1, 42]
    Check(list.last)["before append"]
    list << 2
    Check(list.last)["after append"]
  end

end

__END__

Array - appending: 
  ok: 
    list.last before append: 42
    list.last after append: 2