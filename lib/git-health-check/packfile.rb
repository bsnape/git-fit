module GitHealthCheck
  class Packfile

    attr_reader :count
    attr_reader :size
    attr_reader :in_pack
    attr_reader :pack_count
    attr_reader :size_of_pack
    attr_reader :prune_packable
    attr_reader :garbage

    def initialize
      @git_lib = GitHealthCheck::GitLib.new
    end

    def packfile_stats
      stats = @git_lib.count_objects
      @count, @size, @in_pack, @pack_count, @size_of_pack, @prune_packable, @garbage = stats.split("\n").map do |stat|
        stat.scan /\d+/
      end
    end

  end
end
