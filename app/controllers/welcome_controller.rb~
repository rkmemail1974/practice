class WelcomeController < ApplicationController
  def index
    Pusher['private-test-channel'].trigger('new_message', {:from => "test name", :subject => "test subject"})
  end
end
