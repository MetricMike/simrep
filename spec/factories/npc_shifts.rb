FactoryGirl.define do
  factory :npc_shift do

  trait :with_associations do
    character_event build_stubbed(:character_event)
  end

  end

end
