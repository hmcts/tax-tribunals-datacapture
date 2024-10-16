class AppealHomeController < ApplicationController
  include StartingPointStep

  def index
  end

  private

  def intent
    Intent::TAX_APPEAL
  end
end
