class EuExitPage < BasePage
  set_url "/#{ENV.fetch('TEST_LOCALE', nil)}/steps/#{@pathway}/eu_exit"

  def initialize(pathway)
    @pathway = pathway
  end

  section :content, '#main-content' do
    element :header, 'h1'
  end
end
