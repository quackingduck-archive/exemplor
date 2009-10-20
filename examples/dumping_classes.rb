require 'exemplor'

eg "class name is printed when example returns a class" do
  Object
end

eg "class name is printed when check is given a class" do
  Check(Object)
end

__END__

(i) class name is printed when example returns a class: Object
(I) class name is printed when check is given a class: 
  (i) Object: Object