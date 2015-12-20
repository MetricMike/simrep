FactoryGirl.define do
  factory :character_event do
    character_id 1
    event_id 1
    paid false
    cleaned false
    accumulated_npc_timeunits 0
    accumulated_npc_money 0
    accumulated_npc_money_currency "VMK"
    awarded false
  end
end