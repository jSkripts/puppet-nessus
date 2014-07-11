require 'spec_helper'

describe 'nessus' do
  ['RedHat'].each do |system|
  
    let(:facts) {{ :osfamily => system }}

    it { should contain_class('nessus::install') }
    it { should contain_class('nessus::config') }
    it { should contain_class('nessus::service') }

    describe "nessus::install on #{system}" do
      let(:params) {{ :pacakge_ensure => 'present', :package_name => 'nessus', }}
      it { should contain_package('nessus').with_ensure('present') }

      describe 'should allow package ensure to be overridden' do
        let(:params) {{ :package_ensure => 'latest', :package_name => 'nessus' }}
        it { should contain_package('nessus').with_ensure('latest') }
      end

      describe 'should allow the package name to be overriden' do
        let(:params) {{ :package_ensure => 'present', :package_name => 'wat' }}
        it { should contain_package('wat') }
      end
    end

    describe 'ntp::service' do
      let(:params) {{
        :service_manage => true,
        :service_enable => true,
        :service_ensure => 'running',
        :service_name   => 'nessus',
      }}

      describe 'with defaults' do
        it { should contain_service('nessus').with(
          :enable => true,
          :ensure => 'running',
          :name   => 'nessus',
        )}
      end

      describe 'service_ensure' do
        describe 'when overriden' do
          let(:params) {{ :service_name => 'nessus', :service_ensure => 'stopped' }}
          it { should contain_service('nessus').with_ensure('stopped') }
        end
      end

      describe 'service_manage' do
        let(:params) {{
          :service_manage => false,
          :service_enable => true,
          :service_ensure => 'running',
          :service_name   => 'nessus',
        }}

        it 'when set to false' do
          should_not contain_service('nessus').with({
            'enable' => true,
            'ensure' => 'running',
            'name'   => 'nessus',
          })
        end
      end
    end
  end


