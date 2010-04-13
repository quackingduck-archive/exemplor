require 'exemplor'

eg 'Some successes, then an info' do
  list = [1, 2, 3]
  Assert(list.first ==1)
  Assert(list[1] == 2)
  Show(list.last) # the info one
  Assert(list[2] == 3)
end

__END__

- name: Some successes, then an info
  status: info (with checks)
  result: 
  - name: list.first ==1
    status: success
  - name: list[1] == 2
    status: success
  - name: list.last
    status: info
    result: 3
  - name: list[2] == 3
    status: success