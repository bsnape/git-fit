require_relative 'spec_helper'

describe 'git commands' do

  before(:all) do
    @path    = File.dirname(__FILE__) + '/fixtures/testrepo.git/'
    @repo    = Rugged::Repository.new(@path)
    @git_lib = GitFit::GitLib.new
    Dir.chdir @path
  end

  it 'should list all the file paths in the repository for a given treeish' do
    @git_lib.get_file_list('HEAD').should match_array ['test.txt', 'test/blah/hello.txt']
  end

  it 'should get the commit author for a given commit' do
    @git_lib.get_commit_author('25097b1').should eq 'Ben Snape'
  end

end
