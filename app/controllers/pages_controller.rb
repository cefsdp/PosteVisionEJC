class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @navbar = true
    if user_signed_in?
    end
  end
end
