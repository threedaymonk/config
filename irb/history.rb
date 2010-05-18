HISTFILE = "~/.irb_history"
MAXHISTSIZE = 100
begin
  histfile = File::expand_path(HISTFILE)
  if File::exist?(histfile)
    lines = IO::readlines(histfile).map{ |line| line.chomp }
    Readline::HISTORY.push *lines
  end
  Kernel::at_exit do
    lines = Readline::HISTORY.to_a.reverse.uniq.reverse
    lines = lines[-MAXHISTSIZE, MAXHISTSIZE] if lines.nitems > MAXHISTSIZE
    File::open(histfile, File::WRONLY|File::CREAT|File::TRUNC) do |io| 
      io.puts *lines
    end
  end
end
