require 'exemplor'

Examples 'Array' do
  
  setup { @array = [1, 2, 3] }

  eg 'modified env' do
    @array << 4
    Check(@array).is([1,2,3,4])
  end
  
  eg 'unmodified env' do
    Check(@array).is([1,2,3])
  end

end

__END__

Array - modified env: 
  ok: 
    "@array": 
    - 1
    - 2
    - 3
    - 4
Array - unmodified env: 
  ok: 
    "@array": 
    - 1
    - 2
    - 3