# Thanks to mislav
#
# http://stackoverflow.com/questions/298314/find-files-in-git-repo-over-x-megabytes-that-dont-exist-in-head
module GitHealthCheck

  class History

    MEGABYTE = 1024 ** 2

    def initialize(options)
      @repository = options[:repository]
      @bytes_threshold = options[:threshold].to_f * MEGABYTE
      @git_lib = GitHealthCheck::GitLib.new
    end

    def search
      revision_list = @git_lib.get_revision_list.split "\n"
      big_files = {}

      revision_list.each do |commit|
        @git_lib.get_treeish_contents(commit).split("\0").each do |object|
          bits, type, sha, size, path = object.split
          next if File.exist?("#@repository/#{path}")
          size = size.to_f
          big_files[path] = [sha, size, commit] if size >= @bytes_threshold
        end
      end

      big_files = big_files.map do |path, (sha, size, commit_sha)|
        where = @git_lib.get_commit_details commit_sha
        who = @git_lib.get_commit_author commit_sha
        [sha, (size / MEGABYTE).round(2), path, where, who]
      end

      big_files.sort_by! { |a| [a[1], a[2]] }.reverse!

    end

  end
end
