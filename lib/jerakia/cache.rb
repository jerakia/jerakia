#
# Very primitive form of cache - but we'll make this smarter
#
#
class Jerakia::Cache
  @bucket = {}

  class << self
    attr_reader :bucket
  end

  def initialize
  end

  def add(index, data, metadata={})
    self.class.add(index,data, metadata)
  end

  def self.add(index, data, metadata={})
    @bucket[index] ||= {}
    ## The cache bucket is a global class object, therefore we should
    ## always store a copy of the data object, not the actual object
    ## to ensure that it is not referenced and tainted by the lookup
    #
    set_metadata(index, metadata)
    @bucket[index][:content] = Marshal.load(Marshal.dump(data))
  end

  def self.set_metadata(index, metadata)
    @bucket[index][:metadata] = Marshal.load(Marshal.dump(metadata))
  end

  def self.metadata(index)
    if in_bucket?(index)
      Marshal.load(Marshal.dump(@bucket[index][:metadata]))
    end
  end


  def in_bucket?(index)
    self.class.in_bucket?(index)
  end

  def self.in_bucket?(index)
    bucket.has_key?(index)
  end

  ## default behaviour is always validate if exists.
  def valid?(index)
    in_bucket?(index)
  end

  def purge(index)
    self.class.purge(index)
  end

  def self.purge(index)
    @bucket.delete(index)
  end

  def get(index)
    self.class.get(index)
  end

  def self.get(index)
    data = @bucket[index][:content]
    Marshal.load(Marshal.dump(data))
  end

  def bucket
    self.class.bucket
  end
end
