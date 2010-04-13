require 'exemplor'

eg 'Assertion failure' do
  list = [1, 2, 3]
  Assert(list.first == 2)
end

__END__

- name: Assertion failure
  status: failure
  result: 
  - name: list.first == 2
    status: failure