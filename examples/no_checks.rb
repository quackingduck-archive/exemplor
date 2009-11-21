require 'exemplor'

eg 'An example block without any checks prints the value of the block' do
  "foo"
end

__END__

- name: An example block without any checks prints the value of the block
  status: info (no checks)
  result: foo