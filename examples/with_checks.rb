require 'exemplor'

eg 'Accessing different parts of an array' do
  list = [1, 2, 3]
  Check(list.first)
  Check(list[1])
  Check(list.last)
end

__END__

- name: Accessing different parts of an array
  status: info (with checks)
  result: 
  - name: list.first
    status: info
    result: 1
  - name: list[1]
    status: info
    result: 2
  - name: list.last
    status: info
    result: 3