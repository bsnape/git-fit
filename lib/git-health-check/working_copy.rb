module GitHealthCheck

  class WorkingCopy

    def initialize(repository)
      @repository = repository
      @git_lib = GitHealthCheck::GitLib.new repository
    end

    def fast_find_in_working_copy(number=10)
      raise 'no packs found' if @git_lib.get_pack_number == 0
      objects = `git verify-pack -v .git/objects/pack/pack-*.idx | grep -E 'tree|blob' | sort -k4nr`

      objects = objects.split("\n")

      test = {}

      objects.each do |object|
        break if test.size == number
        sha = object.match(/^\w+/)[0]
        #path = `git rev-list --all --objects | grep #{sha} | cut -f 2 -d ' '`.chomp
        path = `git rev-list --all --objects | grep #{sha}`.match(/\w+\s(.*)/)[1]
        # an empty path means you need to do a garbage collection
        next unless File.exist?("#@repository/#{path}")

        sha, type, size, size_in_pack, offset = object.split

        # convert from byte to kilobyte
        size = (size.to_f / 1024).round 2
        size_in_pack = (size_in_pack.to_f / 1024).round 2

        test[sha] = [size, size_in_pack, path]
      end

      test
    end


  end
end
