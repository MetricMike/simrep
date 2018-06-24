# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).
(Lol, it tries to, but SemVer is hard. Especially given this project's constraints.)

## [Unreleased](#) - ????-??-??
### Added
- .env so we can run from outside again
- Hella and Thundermark are first-class Cultures now

### Fixed
- admin/character.rb translates event id to weekend so killing characters works again
- Active Deaths now correctly search >= <= instead of <= >=
- Bootsnap loads correctly now
- Characters without events are viewable again

### Broke
- ? A bunch of foreign_keys got deleted and I'm not entirely sure why or how
- bootstrap-slider and bootstrap-sortable aren't compatible with bootstrap 4

### Changed
- Ruby version bump :D
- Bundle updated EVERYTHING (twice)

### Removed

## [2.8.4](v2.8.4) - 2017-11-22
### Added
- Link to "view on site" for characters from the index

### Fixed
- Characters without events are viewable again

## [2.8.3](v2.8.3) - 2017-10-20
### Added
- bin/start_app reports time when ran to make logs more readable
- Statistics page on Admin (frequencies!)

### Fixed
- Locking AthenaPDF to version 2

## [2.8.2](v2.8.2) - 2017-09-21
### Added
- SUPER aggressive XP caching because I'm tired of waiting for characters#index

### Fixed
- Bank Accounts CSV is actually useful instead of just primary IDs everywhere

### Changed
- Upgraded all docker images
- Upgrading to Redis4
- Upgrading to Sprockets4
- Turning off halting ActiveRecord callback chains on returning false

## [2.8.1](v2.8.1) - 2017-09-14
### Changed
- bin/restore_db no longer chokes (or overwrites) if $FILE exists

## [2.8.0](v2.8.0) - 2017-09-14
### Fixed
- fixed admin view of special_effects datefield
- dumping local db overwrites $FILE if it exists
- character sheet perm stats reflect new algorithm

### Changed
- only active special effects show up on a character sheet now

### Removed
- lots of unused death/perm code

## [2.7.0](v2.7.0) - 2017-09-13
### Added
- option to dump local production db with bin/restore_db
- oauth id and retirement xp on admin/user#edit

### Fixed
- Bank transactions/items from Admin successfully redirect

### Broke

### Changed
- bootstrap alpha6 -> beta
- temporary effects are now special effects (because not all effects are temporary)
- deaths panel only shows on character sheet if they exist

### Removed
- confirm options on admin/user#edit
- bin/restore_db no longer uses --verbose when restoring

## [2.6.0](v2.6.0) - 2017-09-10
### Added
- Retirement XP is shown on the Characters Index page
- Retire Characters Button (for admins)
- Fancy ass death percentages over time graphs!
- More CLI feedback when using bin/restore_db
- GroupMemberships in Admin (thanks Stonecropt Sentinels!)

### Fixed
- characters#projects now displays (order of operations matters!)

### Broke

### Changed
- Retired Characters can be viewed for historical/vanity purposes

### Removed
- Don't need "name" to log in with local/developer auth anymore

## [2.5.0](v2.5.0) - 2017-07-12
### Added
- Group BankAccounts display now as well
- Print-view for all characters and bank accounts

### Changed
- Totes fixed BankAccounts

### Removed
- Rake DB tasks in favor of the shell script from 2.2.0 / 460803cb

## [2.4.0](v2.4.0) - 2017-07-04
### Added
- Heroku Import and DB Snapshot tasks

### Changed
- Formatting

### Broke
- Adding BankItems & BankTransactions from the WebUI (they go through, but BACK is broken)

## [2.3.1](v2.3.1) - 2017-05-28
### Changed
- Fixed character#show links (specifically #print)
- Bundle and Ruby updates
- Sidekiq prints will try to print offline by default

## [2.2.1](v2.2.1) - 2017-04-09
### Changed
- Added lambdas to the admin pages, which removes ActiveAdmin trying to read the DB on load, which solves a race condition when recreating the app from scratch.

### Removed
- Lots of duplication (BankAccounts have largely been consolidated on the admin pages)
- Consolidated admin versions

## [2.2.0](v2.2.0) - 2017-04-04
### Added 
- Filter by player name on admin/characters
- Compose runs dev and production at the same time
- Script for syncing heroku db to mtower db (I only do this at events and
  I forget the steps every time, adding 10 minutes and panic every check-in)
- Nginx reverse proxy for pretty urls (simrep.simterra.lan vs http://localhost:3000)
- Nginx web server for faster static file serving
- Longer timeouts for dev requests (from 1min->5min) for debugging
- Lograge for prettier logs
- Use cookies for SessionStore in Dev (less redis instances needed)
- Add michael's FB UID to seeds.rb so I don't have to enter 5 stupid commands to "login-with-one-click"
- Moar automated cloud testing with circleci (is actually broken as of this version)

### Changed
- Prefix background jobs by environment
- Reorganized Gemfile (less global requires, moar speed)
- Adjusted bin/start_app (moar db automation)
- Cleaned up application.rb and environment files (logging, comments)
- Return early from seeds.rb if DB isn't empty.
- Cleaned up docker-compose.yml and .env files
- Fancier footer

### Removed
- Removed active\_admin\_csv\_importable
- I don't have a staging environment, so I don't need a staging db URL
- LetterOpenerWeb, I don't have any mailers

## [2.1.1](v2.1.1) - 2017-03-12
### Changed
- Moar automated cloud testing

## [2.1.0](v2.1.0) - 2017-03-07
### Added
- Better styling on Bank Accounts (personal should be viewable for everybody again)
- Faster, more reliable Character Sheet and Bank Account pdf dumping
- Profile badge while on local

### Changed
- Docker gets its own directory for better organization
- Should be smoother to switch environments between dev/prod now

### Removed
- No more caching in dev
- WickedPDF and leftovers (Capistrano, Guard, Procfiles)

## [2.0.0](v2.0.0) - 2017-02-01
### Added
- Fancy selectize fields now select on Tab (thank you Nick Blue)
- Re-enabled Rollbar for error tracking, yey.
- JSONApi for client-side updates and external use (pipe dream!)
- PGHero for more info on DB queries and performance
- Reworked character creation page, more guidance (sorta N & S buttons haven't been made yet)
- New characters will set the "costumed checked at" on character creation
- All tables are sortable!!!

### Changed
- Consolidated AA gems/plugins
- Consolidated SCSS files
- Source is no longer required, but will auto-load related models.
- Birthrights and Origins have been split into 2 separate models 
- All chapters now correctly report 31 as the starting XP (with the option for temporary boosts)
- Upgraded to Bootstrap4 for user facing views
- Fixed the collapsible navbar, so mobile SimRep won't literally kill you
- Birthrights/Origins now properly source Templates on the Admin view
- Development Chapters have random default_xp values (31..131)
- Bonus Chapter XP generalized for all chapters, not just Holurheim
- Updated perm counters to use the simplified death system
- LOL PROTOS SHOULD MULTIPLY SP NOT EXP
- Ghosts get XP after perming again

### Removed
- PCs can no longer move themselves between chapters, will require manual intervention by staff.
- I've broken up with web_console in production, as more and more concurrency is used
- PDF creation is broken
- Don't award bonus chapter xp if 0

## [1.21.0](v1.21.0) - 2016-12-22
### Added
- Travis CI/CD -> Heroku
- Clarifications on SignUp/LogIn page
- CMD for starting up web servicve to dockerfile (will often be pushing ONLY web)

### Changed
- Used default (to the docker/ruby image) location for bundler
- Require only the redis containers needed on web/worker services

### Removed
- Removed Hirb from pryrc by default. SimRep is column-heavy so Hirb is usually less than helpful. I might change my mind when I upgrade to 4K monitors.
- worker service no longer checks bundle or assets

## [1.20.0](v1.20.0) - 2016-12-21
### Added
- Docker-ized
- Added Chapters to seeds, fixes a lot of development work
- Added redis for cache, session, and background jobs
- Added sidekiq for background jobs
- Added lograge as the default logger
- Added letter\_opener\_web for non-production
- Added rescue in case ActiveAdmin gets loaded with an empty DB

### Changed
- Bundle update and reset bin/
- Switched server to puma (again)
- Using .env and sourcing instead of figaro/dotenv
- Updated action_mailer host to use simterra.net instead of herokuapp.com

### Removed
- Cleaned up a lot of unused comments/defaults in environment files

## [1.19.5](v1.19.5) - 2016-12-10
### Added
- Turn event/xp log back on.
- Bundle Update
- N+1 Optimizations for Admin Character/Event pages

## [1.19.1](v1.19.1) - 2016-11-03
### Added
- Sorting on admin#characters on player name and character name

## [1.19.0](v1.19.0) - 2016-10-28
### Changed/Fixed
- Better organization on the characters index. Shows your most recently used
characters first and shows all chapters

## [1.18.6](v1.18.6) - 2016-08-02
### Added
- Character#Show shows unspent points in bold for errything.
- YAAASSS MASS PAYMENTS FOR THOSE 20-CHARACTER MODS 

### Fixed
- More explicit group associations, should stop a few things from breaking
- Characters only have personal bank accounts, groups only have group bank accounts

## [1.18.1](v1.18.1) - 2016-07-27
### Removed
- Goodbye, Capistrano. BoW does not like you.
- Rack servers and BoW are not playing nice, so goodbye rack servers.

### Fixed
- Attend event works in admin again.
- Moving chapters actually costs TUs now.
- Capistrano is broke not woke.
- Better conditionals on some logging gems.

## [1.17.0](v1.17.0) - 2016-07-23
### Added
- Groups! Backend only at the moment. Stores bylaws for access to bank accounts.
- Bank Accounts start with a balance of 0 and receive an initial transaction of 5 marks/kroner.

### Changed

## [1.16.0](v1.16.0) - 2016-07-10
### Added
- Fancy deploys with capistrano (makes it easier to develop fixes and features without downtime)
- New characters display how many skillpoints they start with
- New characters are associated with a chapter (also fixes missing bank accounts)
- Hellan Kroner is now the default (and only) currency in Holurheim.

### Changed / Fixed
- Fixed an issue where new characters would generate multiple bank accounts
- Moving a character between chapters costs 1 TU and warns the player before doing so.
- Removed CoffeeScript which should help resolve a bug where the admin/back office wouldn't load properly unless refreshed
- Renamed NpcShift#open to NpcShift#active to remove a conflict with Kernel#open
- Removed some unnecessary eager loading
- Removed the fancy css, it got in the way too much :broken_heart:
- BonusExperience uses the datepicker now
- Partial reverts for select2/ize in back office due to rails5 incompatibilities. Turning on slowly.

## [1.15.0](v1.15.0) - 2016-06-15
### Added
- Professions are somewhat paid automatically (manual script that needs to be
  run, doesn't support multiple professions or completed specialties yet)
- Support for profession pay rates

### Changed/Fixed
- NpcShift payments are paid to the chapter you NPCed at
- Switched from passenger to puma (includes more db connections)
- Code quality gardening
- Fixes for Rails5 deprecations
- Safer/more accurate Character and association lookups

## [1.14.0](v1.14.0) - 2016-06-10
### Added
- Email-only login if running from MTOWER (at the event)

### Changed / Fixed

## [1.12.3](v1.12.3) - 2016-06-09
### Added
- Recent/active players scope and simpler csv export
- Prettier backend because it needs to be fabulous (super green).

### Changed / Fixed
- Broke something on crafting points, I'm not sure when. It's fixed now, so hooray?
- Removed responsive styles, mobile devices aren't ever used anyways.

## [1.12.2](v1.12.2) - 2016-06-08
### Changed / Fixed
- Fixed an incorrect variable name in the admin character view

## [1.12.1](v1.12.1) - 2016-06-08
### Changed / Fixed
- Fuck versions.

## [1.12.0](v1.12.0) - 2016-06-08
### Changed / Fixed
- Safer project display (I think)
- Turned off inheritance AGAIN on crafting points (should be able to view bank accounts again)
- Switching chapters as the first action should no longer crash simrep
- Added chapters and bonus xp to Admin Character views
- Delegate "weekend" through character_event to event (Fixes some views)
- Better db migrations? (take 4)

## [1.11.4](v1.11.4) - 2016-5-30
### Changed / Fixed
- Everyone signs into Bastion as a default. Sorry Holurheim.
- Better db migrations? (take 3)

## [1.11.0](v1.11.0) - 2016-5-30
### Added
- Using paper_trail-globalid
- Selectize for user/ select inputs
- Current/Switch chapter button in the navbar!
- Explicitly ask for Player/OOC or Character/INC Name
- Sample Origins/Skills/Perks to help normalize the database!
- Added "Spellsword" and "Prestige" sources for Skills
- Redid characters#new
  - tooltips, sample skill/perk names, no more unlimited perks/skills
  - Holurheim Bonus XP is added to new characters now.
- No more passwords, login through Facebook.
- No more confirmable (or validatable)!

### Changed / Fixed
- Upgrade EVERYTHING (rails 5 plus bundle update)
- No more spring, it's broken on BashOnWindows
- Updated styling for web_console
- Removed some unnecessary coffeescript for the XP/Events modal on character#show 
- Remove require_tree, better isolation between user/ and admin/ js
- ACTUALLY make Holurheim's Bonus XP 40. 1.10.0's fix was a total lie I don't know how that got in there.
- Characters with Proto Revelation now have a max investment limit of 6
- Renamed "Fighter" to "Melee"
- Renamed "Marksman" to "Ranged"
- Upgraded to Turbolinks5 (woo speedy)

## [1.10.0](v1.10.0) - 2016-5-7
### Added
- Support for Proto Revelation (triple skillpoints)
- (Admin) Deaths now link to Character
- (Admin) Characters now link to User
- (Admin) Banks now display their Chapter
- (Admin) Bank Transactions & Items now link to Bank Accounts
- (Admin) Bank Transactions can be filtered on memo
- (Admin) Characters now display ALL of their bank accounts
- Bank Accounts now display what chapter they're in
- Better DevTools/console improvements

### Fixed
- Holurheim Bonus XP is now 40 (still provides only 4, but cleaner for gifting skillpoints to other characters)
- Don't pay NPCs unless they pay for the event
- Only give TU, etc. awards to paying players
- Updated wkhtmlpdf - PDF printing works in windows (and heroku, but that wasn't broken?)
- Protos now properly double skillpoints without messing with their experience.
- Using the MUCH shorter character history as the default link
- Death#display_name uses a character name not Character:0x0404wtf00
- A default bank account is only created once per chapter, not every time a character is saved.
- NPC Shifts can be deleted before a payment is issued without crashing the app
- Only award retirement XP once per event and only if the event is paid for
- A character can attend an event multiple times and I no longer override (important for marking payments and cleaning separately)
- CharacterEvent#paid and #cleaned default to false
- User retirement xp pools default to 0

### Broken

## [1.8.0](v1.8.0) - 2016-4-29
### Fixed
- Auto-assigned anyone created in the last week to Holurheim

## [1.8.0](v1.8.0) - 2016-4-29
### Added
- Bonus Experience! Now Staff XP, Retirement XP, and other miscellany will no longer be weird events from before anyone was ever born.
- Retirements! Can only be done by the console for the moment, but retired XP is added automatically after events.
- Chapters! Bastion and Holurheim are partitioned off by the Atlantic Ocean and some SELECT clauses.
- Characters created in Holurheim start with 35 more XP for a total of 4 skill points

### Changed
- Added Perks now appropriately gives your costume level in perk points not costume level + 1.
- Bank Accounts now start with 5 Venthian marks instead of 10.

### Fixed
- The events modal now displays events in chronological order, newest first.

## [1.7.3](v1.7.3) - 2016-3-26
### Added
- Link to this repo.

## [1.7.2](v1.7.2) - 2016-3-20
### Fixed
- NPC Shifts can be reversed for editing without crashing the app.

## [1.7.1](v1.7.1) - 2016-3-20
### Fixed
- Removed January's non-maintenance maintenance message.


## [1.7.0](v1.7.0) - 2016-3-20
### Added
- Ghost detection: ghosts no longer earn experience after they die, and instead earn 5 TU instead of the normal 2.

### Changed
- Added a bunch of UI improvements to Admin, namely select boxes are now select2 boxes and amazing.
  + Bank Accounts are (generally) sorted by owner name instead of by id

### Fixed
- Updated wicked_pdf binary to fix compatibility for something that broke since 1.5.11
- Mass Killing from Admin no longer crashes the app (corrected date->weekend)
- Paid NPC Shifts can have their payments reversed so that their times are editable (this is a lie!)
- Printing a PDF of your character sheet will no longer use up a cleaning coupon

## [1.6.0](v1.6.0) - 2016-3-17
### Added
- Temporary Effects (like increased perm chance for one event)
- Events come with a base willpower. Character Sheets display base willpower.

### Changed
- Cleaned up the override options in BankAccount
- Consolidated and cleaned up `BankTransaction#[post|reverse]_transaction`
- Eager loading in many of the Admin pages should speed up app performance

### Fixed
- Failed transactions no longer raise an exception to crash the app.
- `BankTransaction#reverse_transaction` changes the account balances too.

## [1.5.12](v1.5.12) - 2016-3-17
### Fixed
- Awarding attendance (like when printing a character sheet) requires an explicit override to change pay/clean awards.

## [1.5.11](v1.5.11) - 2016-1-9
### Added
- Versions get their own page on admin for easier reviewing.

### Fixed
- Some spelling fixes.
- Synced local DB to Heroku.

## [1.5.6](v1.5.6) - 2016-1-2
### Fixed
- NPC Shifts are more lenient in determining if they have a linked bank_transaction.

## [1.5.4](v1.5.4) - 2016-1-2
### Fixed
- NPC Shifts before v1.4.0 would throw errors because they couldn't track the bank_transaction associated with them.

## [1.5.3](v1.5.3) - 2016-1-1
### Fixed
- I mistyped in the routes file which broke everything.
- Added ALL the favicons, which should silence routing issues ("I can't find this icon") which were obscuring more important routing issues ("I can't post bank transactions")
- Prettier error pages.

## [1.5.2](v1.5.2) - 2016-1-1
### Fixed
- Fixed a permissions issue when trying to send transactions introduced by [0d995a6](0d995a6) in [1.4.0](v1.4.0).

## [1.5.1](v1.5.1) - 2015-12-31
### Fixed
- Fixed a permissions issue when calculating character deaths.

## [1.5.0](v1.5.0) - 2015-12-30
### Added
- Rollbar integration

### Fixed
- Cleaned up internals for Death and CharacterEvents
- Added `revert_attendence_awards` to CharacterEvent

## [1.4.2](v1.4.2) - 2015-12-30
### Fixed
- Proper links in Changelog
- Deploys to Heroku trigger assets compiling

## [1.4.1](v1.4.1) - 2015-12-30
### Added
- Changelog

## [1.4.0](v1.4.0) - 2015-12-30
This was a HUGE rewrite with about 54 commits since the last push.
Since I don't have a testing strategy yet, it's likely some things are broken.
### Changed
- NPC Shifts have been totally reworked. They track which event they're attached
  to and automatically pay out at their closing. Granularity has been dropped to 15 minutes, so partial payments are a thing.
- Reworked navigation for admins/back office.

### Added
- Each model has an admin page now, some of them have less than useful defaults.
- Exposed version history on admin side for most models (as well as who changed them). Need to use the console for reverts.

### Fixed
- Removed some disabled links and routes to edit pages
- Cleaned the crap out of the admin edit pages. Hooray CSS.
- Nicer flash messages
- Massive speedups on pages that load several characters (and everything along with them).
- Faster experience calculations
- Prettier datetimes.

## [1.3.7](v1.3.7) - 2015-10-04
### Added
- There are some aws settings hanging out after my initial attempt. Eventually will get back to them.
- Version file :)
- Added rspec skeletons, didn't write any tests.

## [1.3.5](v1.3.5) - 2015-10-04
### Fixed
- Deaths are calculated on the fly and properly account for the current event.

## [1.3.4](v1.3.4) - 2015-10-04
### Added
- Used at the November Event.