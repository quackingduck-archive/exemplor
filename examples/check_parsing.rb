require 'exemplor'

eg "with brackets" do
  Check(String.new('test'))
end

eg "with brackets and is" do
  Check(String.new('test')).is("test")
end

__END__

(I) with brackets: 
  (i) String.new('test'): test
(s) with brackets and is: 
  (s) String.new('test'): test