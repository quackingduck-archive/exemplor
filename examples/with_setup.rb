require 'exemplor'

eg.setup { @str = "foo" }

eg 'Modified env' do
  @str << " bar"
  Check(@str).is("foo bar")
end

eg 'Unmodified env' do
  Check(@str).is("foo")
end

__END__

- name: Modified env
  status: success
  result: 
  - name: "@str"
    status: success
    result: foo bar
- name: Unmodified env
  status: success
  result: 
  - name: "@str"
    status: success
    result: foo