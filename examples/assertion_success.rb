require 'exemplor'

eg 'Asserting first is first' do
  list = [1, 2, 3]
  Assert(list.first)
end

__END__

- name: Asserting first is first
  status: success
  result: 
  - name: list.first
    status: success