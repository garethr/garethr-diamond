require 'spec_helper'

describe 'diamond::collector', :type => :define do
  supported_osfamily = ['RedHat', 'Debian', 'Solaris']
  supported_osfamily.each do |osfamily|
    context "On #{osfamily}" do
      osrelease = nil
      osrelease = '5.11' if osfamily == 'Solaris'
      let(:facts) {{
        :osfamily               => osfamily,
        :operatingsystemrelease => osrelease,
      }}

      describe 'no parameters for testCollector' do
        let (:title) { 'testCollector' }

        it { should contain_class('diamond') }
        it { should contain_file('/etc/diamond/collectors/testCollector.conf').with_content(/^enabled=True$/) }
      end

      describe 'with options' do
        let (:title) { 'testCollector' }
        let (:params) {{
          :options => {
              'testOption' => 'testValue',
            }
        }}

        it { should contain_file('/etc/diamond/collectors/testCollector.conf').with_content(/^enabled=True\ntestOption = testValue$/) }
      end

      describe 'with sections' do
        let (:title) { 'testCollector' }
        let (:params) {{
          :sections => {
              'testSection' => {
                'testSectionOption' => 'testSectionValue',
              }
            }
        }}

        it { should contain_file('/etc/diamond/collectors/testCollector.conf').with_content(/^enabled=True\n\ntestSection\ntestSectionOption = testSectionValue$/) }
      end
    end
  end
end
