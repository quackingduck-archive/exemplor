require 'exemplor'

eg.setup { @str = "foo" }

eg 'Modified env' do
  @str << " bar"
  Check(@str).is("foo bar")
end

eg 'Unmodified env' do
  Check(@str).is("foo")
end

__END__

(s) Modified env: 
  (s) @str: foo bar
(s) Unmodified env: 
  (s) @str: foo