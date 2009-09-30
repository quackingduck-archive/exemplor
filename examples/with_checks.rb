require 'exemplor'

eg 'Accessing different parts of an array' do
  list = [1, 2, 3]
  Check(list.first)
  Check(list[1])
  Check(list.last)
end

__END__

(I) Accessing different parts of an array: 
  (i) list.first: 1
  (i) list[1]: 2
  (i) list.last: 3