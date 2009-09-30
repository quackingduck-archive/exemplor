require 'exemplor'

eg 'Array appending' do
  list = [1, 42]
  Check(list.last)["before append"]
  list << 2
  Check(list.last)["after append"]
end

__END__

(I) Array appending: 
  (i) list.last before append: 42
  (i) list.last after append: 2