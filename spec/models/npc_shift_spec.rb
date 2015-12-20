require 'rails_helper'

RSpec.describe NpcShift, type: :model do
  describe "the structure of an NpcShift" do
    let(:boring_npc_shift) { build_stubbed(:npc_shift, :with_associations) }
    let(:stuffed_npc_shift) { build_stubbed(:npc_shift, :with_hours) }

    it "is associated with a character and event" do
      # An equal, but more flexible example would test character and event
      # associations separately
      expect(boring_npc_shift).to belong_to(:character_event)
    end

    context "for the number of hours it tracks" do
      it "counts how many have already been awarded" do
        expect(stuffed_npc_shift).to receive(:unallocated_hours)
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
