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

eg "with disambiguation" do
  Check(foo)['bar'].is('bar')
end

__END__

- name: plain call
  status: info (with checks)
  result: 
  - name: foo
    status: info
    result: bar
- name: whitespace after the call (seriously)
  status: info (with checks)
  result: 
  - name: foo
    status: info
    result: bar
- name: comment after the call
  status: info (with checks)
  result: 
  - name: foo
    status: info
    result: bar
- name: with brackets
  status: info (with checks)
  result: 
  - name: String.new('test')
    status: info
    result: test
- name: with brackets and is
  status: success
  result: 
  - name: String.new('test')
    status: success
    result: test
- name: with disambiguation
  status: success
  result: 
  - name: foo bar
    status: success
    result: bar