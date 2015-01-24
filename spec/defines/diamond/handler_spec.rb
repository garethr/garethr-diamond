require 'spec_helper'

describe 'diamond::handler', :type => :define do
  supported_osfamily = ['RedHat', 'Debian', 'Solaris']
  supported_osfamily.each do |osfamily|
    context "On #{osfamily}" do
      osrelease = nil
      osrelease = '5.11' if osfamily == 'Solaris'
      let(:facts) {{
        :osfamily               => osfamily,
        :operatingsystemrelease => osrelease
      }}

      describe 'no parameters for myHandler' do
        let (:title) { 'testHandler' }

        it { should contain_class('diamond') }
        it { should contain_file('/etc/diamond/handlers/testHandler.conf') }
      end

      describe 'with options' do
        let (:title) { 'testHandler' }
        let (:params) {{
          :options => {
              'testOption' => 'testValue',
            }
        }}

        it { should contain_file('/etc/diamond/handlers/testHandler.conf').with_content(/^testOption = testValue$/) }
      end

      describe 'with sections' do
        let (:title) { 'testHandler' }
        let (:params) {{
          :sections => {
              'testSection' => {
                'testSectionOption' => 'testSectionValue',
              }
            }
        }}

        it { should contain_file('/etc/diamond/handlers/testHandler.conf').with_content(/^testSection\ntestSectionOption = testSectionValue$/) }
      end
    end
  end
end
