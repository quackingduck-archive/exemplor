require 'exemplor'

Examples 'Array' do

  eg 'accessing different parts' do
    list = [1, 2, 3]
    Check(list.first).is(1)
  end

end

__END__

Array - accessing different parts: 
  ok: 
    list.first: 1