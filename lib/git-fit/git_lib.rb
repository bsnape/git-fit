module GitFit
  class GitLib

    def get_commit_statistics(commit)
      statistics = `git show -s --format="%an-%at" #{commit}`.strip.split('-')
      { :author => statistics[0], :commit_date => statistics[1].to_i } # TODO seems a bit eurgh
    end

    def get_revision_list(commit)
      `git rev-list #{commit}`.split("\n")
    end

    def get_commit_contents(treeish)
      contents       = `git ls-tree -zrl #{treeish}`.split("\0")
      split_contents = contents.map { |c| c.split(' ') }
      split_contents.map do |bits, type, sha, size, path|
        {
          :bits => bits.to_i,
          :type => type,
          :sha  => sha,
          :size => size.to_i,
          :path => path
        }
      end
    end

    def get_all_blobs
      output = {}

      get_revision_list('HEAD').each do |commit|
        get_commit_contents(commit).each do |commit_contents|
          if commit_contents.fetch(:type) == 'blob'
            output.merge!(commit_contents.fetch(:path) => commit_contents.fetch(:size))
          end
        end
      end

      output
    end

  end
end
