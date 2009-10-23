require 'exemplor'

eg.helpers do
  def foo() 'bar' end
end

eg "plain call" do
  Check(foo)
end

eg "whitespace after the call (seriously)" do
  Check(foo) 
end

eg "comment after the call" do
  Check(foo) # comment!
end

eg "with brackets" do
  Check(String.new('test'))
end

eg "with brackets and is" do
  Check(String.new('test')).is("test")
end

__END__

(I) plain call: 
  (i) foo: bar
(I) whitespace after the call (seriously): 
  (i) foo: bar
(I) comment after the call: 
  (i) foo: bar
(I) with brackets: 
  (i) String.new('test'): test
(s) with brackets and is: 
  (s) String.new('test'): test