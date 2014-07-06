require_relative 'spec_helper'

describe 'git commands' do

  before(:all) do
    @git_repo_path    = File.dirname(__FILE__) + '/fixtures/testrepo.git/'
    @cloned_repo_path = File.dirname(__FILE__) + '/fixtures/testrepo/'
    FileUtils.rm_rf @cloned_repo_path if Dir.exist? @cloned_repo_path
    `git clone #{@git_repo_path} #{@cloned_repo_path}`
    @git_lib = GitFit::GitLib.new
    Dir.chdir @cloned_repo_path
  end

  it 'should get the commit author for a given commit' do
    @git_lib.get_commit_author('25097b1').should eq 'Ben Snape'
  end

  it 'should get the UNIX timestamp for a given commit' do
    expected_time = 1392722405
    @git_lib.get_commit_date('25097b1').should eq expected_time
  end

  it 'should get the revision list for a given commit' do
    expected_revision_list = ['25097b13910521f43a3bbc5236973bcc2a06093b', 'b224a986d123ae3718b1e8762e596b111a4367e0']
    @git_lib.get_revision_list('HEAD').should match_array expected_revision_list
  end

  it 'should get the contents of a commit object' do
    commit_object = 'b224a986d123ae3718b1e8762e596b111a4367e0'
    contents      = @git_lib.get_commit_contents commit_object

    expected_contents =
      [
        {
          :bits => 100644,
          :type => 'blob',
          :sha  => 'f75bf694a920ad720982e0d22f72bcc1e240b090',
          :size => 2307,
          :path => 'test.txt'
        },
        {
          :bits => 100644,
          :type => 'blob',
          :sha  => '9a80a2252780ab97f40ce8292f17fb1447fcb634',
          :size => 7,
          :path => 'test/blah/hello.txt'
        },
      ]

    contents.should match_array expected_contents
  end

  # TODO: edge-case where a blob is replaced by a smaller/larger one with the same path
  it 'should output unique blobs in no particular order' do
    @git_lib.get_all_blobs.should == { 'test.txt' => 2307, 'test/blah/hello.txt' => 7 }
  end

end
