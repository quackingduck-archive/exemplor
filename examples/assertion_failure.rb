require 'exemplor'

eg 'Assertion failure' do
  list = [1, 2, 3]
  Check(list.first).is(2)
end

__END__

(f) Assertion failure: 
  (f) list.first: 
    expected: 2
    actual: 1