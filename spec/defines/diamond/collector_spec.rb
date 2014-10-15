require 'spec_helper'

describe 'diamond::collector', :type => :define do

  context 'no parameters for testCollector' do
    let (:title) { 'testCollector' }

    it { should contain_class('diamond') }
    it { should contain_file('/etc/diamond/collectors/testCollector.conf').with_content(/^enabled=True$/) }
  end

  context 'with options' do
    let (:title) { 'testCollector' }
    let (:params) {{
       :options => {
          'testOption' => 'testValue',
        }
    }}

    it { should contain_file('/etc/diamond/collectors/testCollector.conf').with_content(/^enabled=True\ntestOption = testValue$/) }
  end

  context 'with sections' do
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
