require 'exemplor'

Examples 'Array' do

  eg 'accessing different parts' do
    list = [1, 2, 3]
    Check(list.first).is(1)
    Check(list[1]).is(2)
    Check(list.last).is(1)
    Check(list[2]).is(3) # would be successful but we never get here
  end

end

__END__

Array - accessing different parts: 
  ok: 
    list.first: 1
    list[1]: 2
  failure: 
    list.last: 
      expected: 1
      actual: 3