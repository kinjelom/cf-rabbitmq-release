RSpec.describe 'setup-vars.bash file generation', template: true do
  let(:output) do
    compiled_template('rabbitmq-server', 'setup-vars.bash', manifest_properties).strip
  end
  let(:manifest_properties) do
    { 'rabbitmq-server' => {
      'ssl' => {
        'versions' => tls_versions
      }
    } }
  end

  context 'when tls versions are missing' do
    let(:manifest_properties) { {} }

    it 'uses provided tls versions' do
      expect(output).to include "SSL_SUPPORTED_TLS_VERSIONS=\"['tlsv1.2','tlsv1.1']\""
    end
  end
  context 'when tls versions are configured' do
    let(:tls_versions) { ['tlsv1.2'] }

    it 'uses provided tls versions' do
      expect(output).to include "SSL_SUPPORTED_TLS_VERSIONS=\"['tlsv1.2']\""
    end
  end

  context 'when tls is not a collection' do
    let(:tls_versions) { '' }

    it 'raises an error' do
      expect { output }.to \
        raise_error 'Expected rabbitmq-server.ssl.versions to be a collection'
    end
  end

  context 'when tls collection contain unsupported versions' do
    let(:tls_versions) { ['tlsv1', 'weird-not-supported-version'] }

    it 'raises an error' do
      expect { output }.to \
        raise_error 'weird-not-supported-version is a not supported tls version'
    end
  end
end