# Thanks to mislav
#
# http://stackoverflow.com/questions/298314/find-files-in-git-repo-over-x-megabytes-that-dont-exist-in-head
module GitHealthCheck

  class History

    MEGABYTE = 1000 ** 2

    def initialize(repository, head = 'HEAD', threshold = 0.1)
      @head = head
      @bytes_threshold = threshold.to_f * MEGABYTE
      Dir.chdir repository
      @git_lib = GitHealthCheck::GitLib.new repository
    end

    def search

      big_files = {}

      # list commit objects in chronological order
      IO.popen("git rev-list #@head", 'r') do |rev_list|
        rev_list.each_line do |commit|
          # list contents of the tree object
          `git ls-tree -zrl #{commit.chomp!}`.split("\0").each do |object|
            bits, type, sha, size, path = object.split(/\s+/, 5)
            size = size.to_i
            big_files[sha] = [path, size, commit] if size >= @bytes_threshold
          end
        end
      end

      big_files.map do |sha, (path, size, commit_sha)|
        where = @git_lib.get_commit_details commit_sha
        who = @git_lib.get_commit_author commit_sha
        [sha, size.to_f / MEGABYTE, path, where, who]
      end
    end

  end
end
