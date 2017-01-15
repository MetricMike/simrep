ActiveAdmin.register PaperTrail::Version, as: "Version" do
  menu false

  index do
    selectable_column
    column ("Item") { |v| link_to_if v.item, "#{v.item_type} :##{v.item_id}", [:admin, v.item] }
    column ("Event") { |v| v.event }
    column ("Details") { |v| v.changeset }
    column ("Modified at") { |v| v.created_at.to_s :long }
    column ("Modified by") { |v| User.where(id: v.whodunnit).try(:first).try(:display_name) }
    actions
  end
end