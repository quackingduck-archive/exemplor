require 'exemplor'

eg 'Failures halt execution' do
  list = [1, 2, 3]
  Check(list.first).is(1_000_000) # fail!
  raise "foo" # we never get here
end

__END__

- name: Failures halt execution
  status: failure
  result: 
  - name: list.first
    status: failure
    expected: 1000000
    actual: 1