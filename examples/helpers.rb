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

(i) Example calling helper: foo