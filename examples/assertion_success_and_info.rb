require 'exemplor'

eg 'Some successes, then an info' do
  list = [1, 2, 3]
  Check(list.first).is(1)
  Check(list[1]).is(2)
  Check(list.last) # the info one
  Check(list[2]).is(3)
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
    status: info
    result: 3
  - name: list[2]
    status: success
    result: 3