class FastBigFileFinder

  MEGABYTE = 1000 ** 2

  def initialize(repository)
    #Dir.chdir repository
    @repository = repository
    @git_lib = GitLib.new repository
  end

  def fast_find_in_history(number=10)
    raise 'no packs found' if @git_lib.get_pack_number == 0
    objects = `git verify-pack -v .git/objects/pack/pack-*.idx | grep -E 'tree|blob' | sort -k4nr`

    objects = objects.split("\n")

    test = {}

    objects.each do |object|
      break if test.size == number
      sha = object.match(/^\w+/)[0]
      path = `git rev-list --all --objects | grep #{sha} | cut -f 2 -d ' '`.chomp
      # an empty path means you need to do a garbage collection
      next if File.exist?("#@repository/#{path}")

      # horrible regex because git verify-pack output can differ - http://www.kernel.org/pub/software/scm/git/docs/git-verify-pack.html
      size, compressed_size = object.match(/\w+\s*\w+\s*(\w+)\s*(\w+)\s*\w+\s*\w+\s*\w+\s*/).captures.map { |c| (c.to_f / 1024).round 2 }

      test[sha] = [size, compressed_size, path]
    end
    test
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
      next unless File.exist?("#@repository/#{path}")

      size, compressed_size = object.match(/\w+\s*\w+\s*(\w+)\s*(\w+)\s*\w+\s*\w+\s*\w+\s*/).captures.map { |c| (c.to_f / 1024).round 2 }

      test[sha] = [size, compressed_size, path]
    end

    test
  end


end
