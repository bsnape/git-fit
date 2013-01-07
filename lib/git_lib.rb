class GitLib

  def initialize(repository_path)
    Dir.chdir repository_path
  end

  def get_commit_author(commit_sha)
    `git log #{commit_sha} -n 1 | grep Author | cut -f 2- -d ' '`.chomp
  end

  def get_commit_details(commit_sha)
    `git show -s #{commit_sha} --format='%h: %cr'`.chomp
  end

  def get_pack_number
    `ls .git/objects/pack/pack-*.idx 2> /dev/null | wc -l`.to_i
  end

end
