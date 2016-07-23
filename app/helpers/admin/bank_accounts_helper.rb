module Admin::BankAccountsHelper
  # Returns a dynamic path based on the provided parameters
  def sti_bank_path(type = "personal", account = nil, action = nil, admin: false)
    if admin
      send "admin_#{format_sti(action, type, account)}_path", account
    else
      send "#{format_sti(action, type, account)}_path", account
    end
  end

  def format_sti(action, type, account)
    action || account ? "#{format_action(action)}#{type.underscore}" : "#{type.underscore.pluralize}"
  end

  def format_action(action)
    action ? "#{action}_" : ""
  end
end
