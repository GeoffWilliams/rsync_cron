require 'spec_helper'
describe 'rsync_cron' do

  context 'with defaults for all parameters' do
    it { should contain_class('rsync_cron') }
  end
end
