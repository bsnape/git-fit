require './report'

class HealthCheck

  def initialize(repository)
    @repository = repository
    Dir.chdir @repository
  end

  def status
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

end
