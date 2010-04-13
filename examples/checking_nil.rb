require 'exemplor'

# this is kind of a compromise, looking for better ideas

eg "checking nil works correctly" do
  Show(nil)
end

eg "asserting for nil works correctly" do
  Assert(nil == nil)
end

__END__

- name: checking nil works correctly
  status: info (with checks)
  result: 
  - name: nil
    status: info
    result: 
- name: asserting for nil works correctly
  status: success
  result: 
  - name: nil == nil
    status: success