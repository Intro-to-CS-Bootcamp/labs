require 'json'

IO.readlines(ARGV[0]).each do |line|
  line == "\n" ? next : line.chomp!

  if line == "file start"
    @jarray = []
    @chapter = {}
  elsif @chapter.empty?
    @chapter["chapter"] = line
    @chapter["questions"] = []
    @q = {}
  elsif line == "chapter end"
    @chapter["questions"].push(@q)
    @jarray.push(@chapter)
    @chapter = {}
  else
    if line == "true" || line == "false"
      if !@q.empty?
        @chapter["questions"].push(@q)
        @q = {}
      end
      @q["exact"] = line == "true"
    elsif @q.length == 1
      @q["answer"] = line
      @q["question"] = []
    else
      @q["question"].push(line)
    end
  end
end


File.open(ARGV[0][0, ARGV[0].length - 4] + ".json", "w") do |f|
  f.write(@jarray.to_json)
end
