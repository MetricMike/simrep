FactoryGirl.define do
  factory :npc_shift do
    character_event create(:character_event)
  end
end
