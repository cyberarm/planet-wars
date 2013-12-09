class Set
  def pop
    a = self.first unless self.first.nil?
    self.delete(a) if a
    return a if a
  end
end