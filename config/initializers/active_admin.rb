ActiveAdmin.setup do |config|
  # == Site Title
  #
  # Set the title that is displayed on the main layout
  # for each of the active admin pages.
  #
  config.site_title = "Back Office"

  # Set the link url for the title. For example, to take
  # users to your main site. Defaults to no link.
  #
  config.site_title_link = "/"

  # Set an optional image to be displayed for the header
  # instead of a string (overrides :site_title)
  #
  # Note: Aim for an image that's 21px high so it fits in the header.
  #
  # config.site_title_image = "logo.png"

  # == Default Namespace
  #
  # Set the default namespace each administration resource
  # will be added to.
  #
  # eg:
  #   config.default_namespace = :hello_world
  #
  # This will create resources in the HelloWorld module and
  # will namespace routes to /hello_world/*
  #
  # To set no namespace by default, use:
  #   config.default_namespace = false
  #
  # Default:
  # config.default_namespace = :admin
  #
  # You can customize the settings for each namespace by using
  # a namespace block. For example, to change the site title
  # within a namespace:
  #
  #   config.namespace :admin do |admin|
  #     admin.site_title = "Custom Admin Title"
  #   end
  #
  # This will ONLY change the title for the admin section. Other
  # namespaces will continue to use the main "site_title" configuration.

  # == User Authentication
  #
  # Active Admin will automatically call an authentication
  # method in a before filter of all controller actions to
  # ensure that there is a currently logged in admin user.
  #
  # This setting changes the method which Active Admin calls
  # within the application controller.
  config.authentication_method = :authenticate_admin!

  # == User Authorization
  #
  # Active Admin will automatically call an authorization
  # method in a before filter of all controller actions to
  # ensure that there is a user with proper rights. You can use
  # CanCanAdapter or make your own. Please refer to documentation.
  # config.authorization_adapter = ActiveAdmin::CanCanAdapter

  # In case you prefer Pundit over other solutions you can here pass
  # the name of default policy class. This policy will be used in every
  # case when Pundit is unable to find suitable policy.
  # config.pundit_default_policy = "MyDefaultPunditPolicy"

  # You can customize your CanCan Ability class name here.
  # config.cancan_ability_class = "Ability"

  # You can specify a method to be called on unauthorized access.
  # This is necessary in order to prevent a redirect loop which happens
  # because, by default, user gets redirected to Dashboard. If user
  # doesn't have access to Dashboard, he'll end up in a redirect loop.
  # Method provided here should be defined in application_controller.rb.
  # config.on_unauthorized_access = :access_denied

  # == Current User
  #
  # Active Admin will associate actions with the current
  # user performing them.
  #
  # This setting changes the method which Active Admin calls
  # (within the application controller) to return the currently logged in user.
  config.current_user_method = :current_user

  # == Logging Out
  #
  # Active Admin displays a logout link on each screen. These
  # settings configure the location and method used for the link.
  #
  # This setting changes the path where the link points to. If it's
  # a string, the strings is used as the path. If it's a Symbol, we
  # will call the method to return the path.
  #
  # Default:
  config.logout_link_path = :destroy_user_session_path

  # This setting changes the http method used when rendering the
  # link. For example :get, :delete, :put, etc..
  #
  # Default:
  config.logout_link_method = :delete

  # == Root
  #
  # Set the action to call for the root path. You can set different
  # roots for each namespace.
  #
  # Default:
  # config.root_to = 'dashboard#index'

  # == Admin Comments
  #
  # This allows your users to comment on any resource registered with Active Admin.
  #
  # You can completely disable comments:
  # config.comments = false
  #
  # You can disable the menu item for the comments index page:
  # config.show_comments_in_menu = false
  #
  # You can change the name under which comments are registered:
  # config.comments_registration_name = 'AdminComment'

  # == Batch Actions
  #
  # Enable and disable Batch Actions
  #
  config.batch_actions = true

  # == Controller Filters
  #
  # You can add before, after and around filters to all of your
  # Active Admin resources and pages from here.
  #
  config.before_action do
    params.permit! #ohgod, but it's just for the admin interface.
  end

  # == Setting a Favicon
  #
  # config.favicon = 'favicon.ico'

  # == Removing Breadcrumbs
  #
  # Breadcrumbs are enabled by default. You can customize them for individual
  # resources or you can disable them globally from here.
  #
  # config.breadcrumb = false

  # == Register Stylesheets & Javascripts
  #
  # We recommend using the built in Active Admin layout and loading
  # up your own stylesheets / javascripts to customize the look
  # and feel.
  #
  # To load a stylesheet:
  #   config.register_stylesheet 'my_stylesheet.css'
  #
  # You can provide an options hash for more control, which is passed along to stylesheet_link_tag():
  #   config.register_stylesheet 'my_print_stylesheet.css', media: :print
  #
  # To load a javascript file:
  #   config.register_javascript 'my_javascript.js'

  # == CSV options
  #
  # Set the CSV builder separator
  config.csv_options = { col_sep: ',' }
  #
  # Force the use of quotes
  # config.csv_options = { force_quotes: true }

  # == Menu System
  #
  # You can add a navigation menu to be used in your application, or configure a provided menu
  #
  # To change the default utility navigation to show a link to your website & a logout btn
  #
  #   config.namespace :admin do |admin|
  #     admin.build_menu :utility_navigation do |menu|
  #       menu.add label: "My Great Website", url: "http://www.mygreatwebsite.com", html_options: { target: :blank }
  #       admin.add_logout_button_to_menu menu
  #     end
  #   end
  #
  # If you wanted to add a static menu item to the default menu provided:
  #
  #   config.namespace :admin do |admin|
  #     admin.build_menu :default do |menu|
  #       menu.add label: "My Great Website", url: "http://www.mygreatwebsite.com", html_options: { target: :blank }
  #     end
  #   end
  config.namespace :admin do |admin|
    admin.build_menu do |menu|
      menu.add label: 'User', url: '#', priority: 5 do |user|
        user.add label: 'Users', url: :admin_users_path
        user.add label: 'Referrals', url: :admin_referrals_path
      end

      menu.add label: 'Character', url: '#', priority: 6 do |character|
        character.add label: 'Characters',             url: :admin_characters_path
        character.add label: 'Backgrounds',            url: :admin_character_backgrounds_path
        character.add label: 'Events',                 url: :admin_character_events_path
        character.add label: 'Origins',                url: :admin_character_origins_path
        character.add label: 'Birthrights',            url: :admin_character_birthrights_path
        character.add label: 'Perks',                  url: :admin_character_perks_path
        character.add label: 'Skills',                 url: :admin_character_skills_path
        character.add label: 'Talents',                url: :admin_talents_path
        character.add label: 'Deaths',                 url: :admin_deaths_path
        character.add label: 'Project Contributions',  url: :admin_project_contributions_path
        character.add label: 'Npc Shifts',             url: :admin_npc_shifts_path
        character.add label: 'Temporary Effects',      url: :admin_temporary_effects_path
        character.add label: 'Bonus Experiences',      url: :admin_bonus_experiences_path
      end

      menu.add label: 'Bank', url: '#', priority: 7 do |bank|
        bank.add label: 'All Bank Accounts',       url: :admin_bank_accounts_path
        bank.add label: 'Personal Bank Accounts',  url: :admin_personal_bank_accounts_path
        bank.add label: 'Group Bank Accounts',     url: :admin_group_bank_accounts_path
        bank.add label: 'Bank Transactions',       url: :admin_bank_transactions_path
        bank.add label: 'Bank Items',              url: :admin_bank_items_path
        bank.add label: 'Crafting Points',         url: :admin_crafting_points_path
      end

      menu.add label: 'Base Models', url: '#', priority: 8 do |base|
        base.add label: 'Chapters',    url: :admin_chapters_path
        base.add label: 'Backgrounds', url: :admin_backgrounds_path
        base.add label: 'Events',      url: :admin_events_path
        base.add label: 'Origins',     url: :admin_origins_path
        base.add label: 'Birthrights', url: :admin_birthrights_path
        base.add label: 'Perks',       url: :admin_perks_path
        base.add label: 'Skills',      url: :admin_skills_path
        base.add label: 'Projects',    url: :admin_projects_path
        base.add label: 'Groups',      url: :admin_groups_path
      end
    end
  end

  # == Download Links
  #
  # You can disable download links on resource listing pages,
  # or customize the formats shown per namespace/globally
  #
  # To disable/customize for the :admin namespace:
  #
  #   config.namespace :admin do |admin|
  #
  #     # Disable the links entirely
  #     admin.download_links = false
  #
  #     # Only show XML & PDF options
  #     admin.download_links = [:xml, :pdf]
  #
  #     # Enable/disable the links based on block
  #     #   (for example, with cancan)
  #     admin.download_links = proc { can?(:view_download_links) }
  #
  #   end

  # == Pagination
  #
  # Pagination is enabled by default for all resources.
  # You can control the default per page count for all resources here.
  #
  config.default_per_page = 15

  # == Filters
  #
  # By default the index screen includes a "Filters" sidebar on the right
  # hand side with a filter for each attribute of the registered model.
  # You can enable or disable them for all resources here.
  #
  # config.filters = true
end
