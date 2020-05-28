class Batch
  def initialize
    puts "[Batch task is in process..]"
    exec
    puts "[Batch task has been completed]"
  end
end
