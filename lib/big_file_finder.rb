# Thanks to mislav
#
# http://stackoverflow.com/questions/298314/find-files-in-git-repo-over-x-megabytes-that-dont-exist-in-head

class BigFileFinder

  MEGABYTE = 1000 ** 2

  def initialize(repository, head = 'HEAD', threshold = 0.1) #0.1
    @head = head
    @threshold = threshold.to_f * MEGABYTE
    Dir.chdir repository
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
          big_files[sha] = [path, size, commit] if size >= @threshold
        end
      end
    end

    big_files.map do |sha, (path, size, commit_sha)|
      where = get_commit_details commit_sha
      who = get_commit_author commit_sha
      [sha, size.to_f / MEGABYTE, path, where, who]
    end

  end

  private

  def get_commit_author(commit_sha)
    `git log #{commit_sha} -n 1 | grep Author | cut -f 2- -d ' '`.chomp
  end

  def get_commit_details(commit_sha)
    `git show -s #{commit_sha} --format='%h: %cr'`.chomp
  end

end
