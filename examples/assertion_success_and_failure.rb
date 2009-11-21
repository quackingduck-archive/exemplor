require 'exemplor'

eg 'Some successes, then a fail' do
  list = [1, 2, 3]
  Check(list.first).is(1)
  Check(list[1]).is(2)
  Check(list.last).is(1)
  Check(list[2]).is(3) # would be successful but we never get here
end

__END__

- name: Some successes, then a fail
  status: failure
  result: 
  - name: list.first
    status: success
    result: 1
  - name: list[1]
    status: success
    result: 2
  - name: list.last
    status: failure
    expected: 1
    actual: 3