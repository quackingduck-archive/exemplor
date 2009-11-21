require 'exemplor'

eg 'Assertion failure' do
  list = [1, 2, 3]
  Check(list.first).is(2)
end

__END__

- name: Assertion failure
  status: failure
  result: 
  - name: list.first
    status: failure
    expected: 2
    actual: 1