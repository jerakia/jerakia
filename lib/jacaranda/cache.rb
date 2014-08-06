#
# Very primitive form of cache - but we'll make this smarter
#
#
class Jacaranda::Cache

  def initialize
    @@bucket = {}
  end

  def bucket_add(index,data)
    @@bucket[index] = data
    data
  end

  def in_bucket?(index)
    @@bucket.has_key?(index)
  end

  def bucket
    @@bucket
  end
end

