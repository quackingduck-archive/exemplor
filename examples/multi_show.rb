require 'exemplor'

eg 'Accessing different parts of an array' do
  list = [1, 2, 3]
  Show(list.first)
  Show(list[1])
  Show(list.last)
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