require 'spec_helper'

  test_options = [
    'MYSQLServer',
    'MYSQLPort',
    'MYSQLSocket',
    'MYSQLUser',
    'MYSQLPassword',
    'MYSQLDatabase',
    'MYSQLCrypt',
    'MYSQLTransactions',
    'MYSQLGetPW',
    'MYSQLGetUID',
    'MYSQLDefaultUID',
    'MYSQLGetGID',
    'MYSQLDefaultGID',
    'MYSQLGetDir',
    'MYSQLForceTildeExpansion',
    'MYSQLGetQTAFS',
    'MYSQLGetQTASZ',
    'MYSQLGetRatioUL',
    'MYSQLGetRatioDL',
    'MYSQLGetBandwidthUL',
    'MYSQLGetBandwidthDL',
  ]

describe 'pureftpd::config::mysql' do

  shared_examples 'config' do |params, content|
    let(:facts) {{ :osfamily=> 'RedHat' }}
    let(:params) { params }

    it do
      should include_class('pureftpd::config::mysql') 
      should contain_file('/etc/pure-ftpd/pureftpd-mysql.conf') \
        .with_ensure('file') \
        .with_content(content)
    end
  end

  all_params  = {}
  all_content = ''
  value = 'xxx'

  # accumutate all of the params and content strings as we test each individual
  # option so we can use them for the next test
  context 'one option at a time' do
    test_options.each do |option|
      params = {}
      params[option.downcase.to_sym] = value
      content = sprintf("%-19s %s\n", option, value)

      all_params.merge!(params)
      all_content += content

      it_behaves_like 'config', params, content
    end
  end
  
  # test all of the known options at once this works because the ordering of
  # options values in the output file is fixed
  context 'all options' do
    it_behaves_like 'config', all_params, all_content
  end

end