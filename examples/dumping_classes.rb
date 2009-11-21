require 'exemplor'

eg "class name is printed when example returns a class" do
  Object
end

eg "class name is printed when check is given a class" do
  Check(Object)
end

__END__

- name: class name is printed when example returns a class
  status: info (no checks)
  result: Object
- name: class name is printed when check is given a class
  status: info (with checks)
  result: 
  - name: Object
    status: info
    result: Object