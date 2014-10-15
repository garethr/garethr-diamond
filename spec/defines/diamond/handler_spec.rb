require 'spec_helper'

describe 'diamond::handler', :type => :define do

  context 'no parameters for myHandler' do
    let (:title) { 'testHandler' }

    it { should contain_class('diamond') }
    it { should contain_file('/etc/diamond/handlers/testHandler.conf') }
  end

  context 'with options' do
    let (:title) { 'testHandler' }
    let (:params) {{
       :options => {
          'testOption' => 'testValue',
        }
    }}

    it { should contain_file('/etc/diamond/handlers/testHandler.conf').with_content(/^testOption = testValue$/) }
  end

  context 'with sections' do
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
