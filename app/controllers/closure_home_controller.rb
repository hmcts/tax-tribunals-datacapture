class ClosureHomeController < ApplicationController
  include StartingPointStep

  def index
  end

  private

  def intent
    Intent::CLOSE_ENQUIRY
  end
end
