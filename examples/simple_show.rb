require 'exemplor'

eg 'Showing the value of some expression' do
  list = [1, 2, 3]
  Show(list.first)
end

__END__

- name: Showing the value of some expression
  status: info (with checks)
  result: 
  - name: list.first
    status: info
    result: 1