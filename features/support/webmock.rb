WebMock.stub_request(:get, "https://www.gov.uk/tax-appeals")
       .to_return(status: 200, body: '<html><body>Disagree with a tax decision</body></html>', headers: {})