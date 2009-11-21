require 'exemplor'

eg "checking nil works correctly" do
  Check(nil)
end

eg "asserting for nil works correctly" do
  Check(nil).is(nil)
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
  - name: nil
    status: success
    result: