require 'exemplor'

eg 'Array appending' do
  list = [1, 42]
  Check(list.last)["before append"]
  list << 2
  Check(list.last)["after append"]
end

__END__

- name: Array appending
  status: info (with checks)
  result: 
  - name: list.last before append
    status: info
    result: 42
  - name: list.last after append
    status: info
    result: 2