class ApplicationController < ActionController::API


# NOTE: shortcut / customer management is out of the scope
def current_customer
  @customer ||= Customer.first
end

end
