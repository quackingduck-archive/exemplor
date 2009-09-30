require 'exemplor'

eg 'Asserting first is first' do
  list = [1, 2, 3]
  Check(list.first).is(1)
end

__END__

(s) Asserting first is first: 
  (s) list.first: 1