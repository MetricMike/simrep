ActiveAdmin.setup do |config|

  config.site_title = "Back Office"

  config.site_title_link = "/"

  config.authentication_method = :authenticate_admin!

  config.current_user_method = :current_user

  config.logout_link_path = :destroy_user_session_path

  config.logout_link_method = :delete

  config.comments_menu = false
  config.batch_actions = true

  config.before_action do
    params.permit! #ohgod, but it's just for the admin interface.
  end

  config.csv_options = { col_sep: ',' }

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

      menu.add label: 'SimRep Admin', url: '#', priority: 9 do |base|
        base.add label: 'Canon Pulls', url: :admin_canon_pulls_path
        base.add label: 'Comments',    url: :admin_comments_path
        base.add label: 'Versions',    url: :admin_versions_path
      end
    end
  end

  config.default_per_page = 15
end
