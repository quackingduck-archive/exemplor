require 'exemplor'

eg.helpers do
  
  def foo
    "foo"
  end
  
end

eg 'Example calling helper' do
  foo
end

__END__

- name: Example calling helper
  status: info (no checks)
  result: foo
