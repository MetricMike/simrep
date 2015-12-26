require 'rails_helper'

RSpec.describe NpcShift, type: :model do
  # During an event, a player can "work for the bank" and play NPCs. Typically,
  # they'll log their starting time and ending time and be paid for that work.
  # If they NPC for a continuous 3 hours, they also have the option to overtime.

  describe "the structure of an NpcShift" do

    it "is associated with a character and event" do
      # An equal, but more flexible example would test character and event
      # associations separately
      expect(NpcShift).to belong_to(:character_event)
    end

    it "only allows one shift to be open at a time" do
      some_character_event = CharacterEvent.first
      first_shift = NpcShift.create!(character_event: some_character_event)
      first_shift.open_shift
      expect(NpcShift.create!(character_event: some_character_event)).to raise ActiveRecord::RecordInvalid
    end

    context "for the number of hours it tracks" do
      it "awards after closing" do
      end
    end
  end

  describe "A PC starts an NPCShift" do
    it "asks if it's going to be dirty" do
    end

  end

  describe "A PC ends an NPCShift" do
    context "and they worked for at least 3 hours" do
      it "allows them to overtime" do
      end
    end

    it "pays them for their time" do
    end
  end
end
