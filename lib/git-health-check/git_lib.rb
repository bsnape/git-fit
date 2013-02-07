module GitHealthCheck
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

    def get_status
      `git status`
    end

    def filesystem_check
      `git fsck --full --strict`
    end

    def garbage_collection
      `git gc`
    end

    def repack
      `git repack -a -d -f --depth=250 --window=250` # better than gc --aggressive
                                                     # http://metalinguist.wordpress.com/2007/12/06/the-woes-of-git-gc-aggressive-and-how-git-deltas-work/
    end

    def count_objects
      `git count-objects -v`
    end

    def get_largest_files(number=10)
      `git ls-files -z | xargs -0 ls -l | sort -nrk5 | head -n #{number}`
    end

    def get_object_sha_from_path(path)
      `git ls-files -s #{path} | cut -d ' ' -f 2`
    end

    def get_revision_list(head='HEAD')
      `git rev-list #{head}`
    end

    def get_treeish_contents(treeish)
      `git ls-tree -zrl #{treeish}`
    end

  end
end
