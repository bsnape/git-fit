module GitHealthCheck
  class GitLib

    def get_commit_author(commit_sha)
      `git log #{commit_sha} -n 1 | grep Author | cut -f 2- -d ' '`.chomp
    end

    def get_commit_details(commit_sha)
      `git show -s #{commit_sha} --format='%h: %cr'`.chomp
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
