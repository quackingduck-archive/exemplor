require 'exemplor'

eg.helpers do
  def foo() 'bar' end
end

eg "plain call" do
  Show(foo)
end

eg "whitespace after the call (seriously)" do
  Show(foo) 
end

eg "comment after the call" do
  Show(foo) # comment!
end

eg "with brackets" do
  Show(String.new('test'))
end

eg "with disambiguation" do
  Show(foo)['bar']
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
- name: with disambiguation
  status: info (with checks)
  result: 
  - name: foo bar
    status: info
    result: bar