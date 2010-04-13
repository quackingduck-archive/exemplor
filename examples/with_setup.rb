require 'exemplor'

eg.setup { @str = "foo" }

eg 'Modified env' do
  @str << " bar"
  Assert(@str == 'foo bar')
end

eg 'Unmodified env' do
  Assert(@str == 'foo')
end

__END__

- name: Modified env
  status: success
  result: 
  - name: "@str == 'foo bar'"
    status: success
- name: Unmodified env
  status: success
  result: 
  - name: "@str == 'foo'"
    status: success