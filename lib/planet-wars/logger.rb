class Logger
  # Includable
  def log(string, klass)
    write_log("#{Time.now.utc.strftime('%H:%M:%S %d/%m/%Y %Z')} | #{klass.class} wrote> #{string}")
  end

  def write_log(string)
    unless File.exists?("./lib/planet-wars/logs") && File.directory?("./lib/planet-wars/logs")
      Dir.mkdir("./lib/planet-wars/logs")
    end

    open("./lib/planet-wars/logs/#{Time.now.utc.strftime('%d_%Y')}_log.txt", "a+") {|f| f.write(string+"\n")}
  end

  # Not includable
  def self.log(string, klass)
    write_log("#{Time.now.utc.strftime('%H:%M:%S %d/%m/%Y %Z')} | #{klass.class} wrote> #{string}")
  end

  def self.write_log(string)
    unless File.exists?("./lib/planet-wars/logs") && File.directory?("./lib/planet-wars/logs")
      Dir.mkdir("./lib/planet-wars/logs")
    end

    open("./lib/planet-wars/logs/#{Time.now.utc.strftime('%d_%Y')}_log.txt", "a+") {|f| f.write(string+"\n")}
  end
end
