WebMock.stub_request(:get, "www.gov.uk")
       .to_return(status: 200, body: '<html><body>Disagree with a tax decision</body></html>', headers: {})
