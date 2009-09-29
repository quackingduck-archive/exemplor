require 'exemplor'

Examples 'Array' do

  eg 'accessing different parts' do
    list = [1, 2, 3]
    Check(list.first).is(2)
  end

end

__END__

Array - accessing different parts: 
  failure: 
    list.first: 
      expected: 2
      actual: 1