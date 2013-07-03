module GitFit

  class WorkingCopy

    def initialize(options)
      @limit = options[:limit]
      @git_lib = GitFit::GitLib.new
    end

    def find_in_working_copy
      largest_files = @git_lib.get_largest_files @limit
      largest_files = largest_files.split "\n"

      files = []

      largest_files.each do |file|
        split = file.split
        size = split[4]
        path = split[8]
        sha = @git_lib.get_object_sha_from_path path
        size = (size.to_f * 9.53674e-7).round 2 # bytes to MB
        files << [sha, size, path] # no hash in case of blob-reuse in various paths
      end

      files
    end

  end
end
