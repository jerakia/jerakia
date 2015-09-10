#
# Very primitive form of cache - but we'll make this smarter
#
#
class Jerakia::Cache

  @@bucket = {}

  def initialize
  end

  def add(index,data)
    @@bucket[index] ||= {}
    ## The cache bucket is a global class object, therefore we should
    ## always store a copy of the data object, not the actual object
    ## to ensure that it is not referenced and tainted by the lookup
    #
    @@bucket[index][:content] = Marshal::load(Marshal.dump(data))
    data
  end

  def in_bucket?(index)
    @@bucket.has_key?(index)
  end

  ## default behaviour is always validate if exists.
  def valid?(index)
    in_bucket?(index)
  end
  
  def get(index)
    data = @@bucket[index][:content]
    Marshal::load(Marshal.dump(data))
  end

  def bucket
    @@bucket
  end
end

