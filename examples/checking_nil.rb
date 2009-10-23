require 'exemplor'

eg "checking nil works correctly" do
  Check(nil)
end

eg "asserting for nil works correctly" do
  Check(nil).is(nil)
end

__END__

(I) checking nil works correctly: 
  (i) nil: 
(s) asserting for nil works correctly: 
  (s) nil: 