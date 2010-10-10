Dir[ENV['HOME']+'/.irb/*.rb'].each do |ext|
  begin
    require ext
  rescue Exception => ex
    puts "error loading #{ext}"
  end
end
IRB.conf[:PROMPT_MODE] = :SIMPLE
