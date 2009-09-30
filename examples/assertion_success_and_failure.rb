require 'exemplor'

eg 'Some successes, then a fail' do
  list = [1, 2, 3]
  Check(list.first).is(1)
  Check(list[1]).is(2)
  Check(list.last).is(1)
  Check(list[2]).is(3) # would be successful but we never get here
end

__END__

(f) Some successes, then a fail: 
  (s) list.first: 1
  (s) list[1]: 2
  (f) list.last: 
    expected: 1
    actual: 3