# takes an array of command line arguments
def Exemplor(args)
  args = args.dup
  if args.delete('--list') || args.delete('-l')
    Exemplor.examples.list(args)
  else
    exit Exemplor.examples.run(args)
  end
end