require 'spec_helper'
describe 'rsync_cron::host', :type => :define do

  let :pre_condition do
    '
    $concat_basedir = "/tmp/concat"
    class { "rsync_cron": }
    '
  end

  # mock the file function, adapted from
  # https://github.com/TomPoulton/rspec-puppet-unit-testing/blob/master/modules/foo/spec/classes/bar_spec.rb
  before(:each) do
    # replace puppet's file() function with one that always returns a fixed string
    MockFunction.new('file') { |f|
      f.stubs(:call).returns('DEADBEEF')
    }
  end

  context 'compiles ok' do
    let :title do
      "rsync@mylaptop.localdomain"
    end
    it { should compile }
  end

end
