module Logger
  # Includable
  def log(string, klass)
    write_log("#{Time.now.utc.strftime('%H:%M %d/%m/%Y %Z')} | #{klass.class} wrote> #{string}")
  end

  def write_log(string)
    open("./lib/planet-wars/logs/#{Time.now.utc.strftime('%d_%Y')}_log.txt", "a") {|f| f.write(string)}
  end

  # Not includable
  def self.log(string, klass)
    write_log("#{Time.now.utc.strftime('%H:%M %d/%m/%Y %Z')} | #{klass.class} wrote> #{string}")
  end

  def self.write_log(string)
    open("./lib/planet-wars/logs/#{Time.now.utc.strftime('%d_%Y')}_log.txt", "a") {|f| f.write(string)}
  end
end
