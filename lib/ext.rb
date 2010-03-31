def OrderedHash(&blk)
  ohsh = OrderedHash.new
  blk.call(ohsh)
  ohsh
end

def YAML.without_header(obj)
  obj.to_yaml.match(/^--- \n?/).post_match
end

class String
  def indent
    self.split("\n").map { |line| '  ' + line }.join("\n")
  end
end
