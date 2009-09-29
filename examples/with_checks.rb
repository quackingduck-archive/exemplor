require 'exemplor'

Examples 'Array' do

  eg 'accessing different parts' do
    list = [1, 2, 3]
    Check(list.first)
    Check(list[1])
    Check(list.last)
  end

end

__END__

Array - accessing different parts: 
  ok: 
    list.first: 1
    list[1]: 2
    list.last: 3