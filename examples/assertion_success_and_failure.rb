require 'exemplor'

eg 'Some successes, then a fail' do
  list = [1, 2, 3]
  Assert(list.first == 1)
  Assert(list[1] == 2)
  Assert(list.last == 1) # fail!
  Assert(list[2] == 3) # would be successful but we never get here
end

__END__

- name: Some successes, then a fail
  status: failure
  result: 
  - name: list.first == 1
    status: success
  - name: list[1] == 2
    status: success
  - name: list.last == 1
    status: failure