class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def set_infos
    @google_maps_key = Settings.google_maps_key
  end
end
