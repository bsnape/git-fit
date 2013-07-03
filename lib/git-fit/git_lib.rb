module GitFit
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

    def get_commit_count_for_branch
      [`git branch | cut -d ' ' -f 2`.strip, `git log --oneline | wc -l`.strip]
      #`git shortlog | grep -E '^[ ]+\w+' | wc -l`.to_i
    end

    def get_commit_count_for_repo
      `git rev-list --all | wc -l`.strip
    end

    def get_contributors
      Dir.chdir "../ITVOnline"
      contributors = `git log | grep ^Author: | sed 's/ <.*//; s/^Author: //' | sort | uniq -c | sort -nr`.split "\n"
      contributors.map! {|c| c.strip}
      p contributors

      a,b = contributors.each {|c| c.scan /\w+/}

      puts a

      #[commit, author] = contributors.split("\n") { |c| c.split(/(\d+)\s(.*)/, 2) }
      #puts [commit, author]
    #p contributors
    end

  end
end
