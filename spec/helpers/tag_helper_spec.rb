# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagHelper, type: :helper do
  let(:tag){ FactoryBot.create(:tag) }
  let(:tags){ [FactoryBot.create(:tag), FactoryBot.create(:tag)] }

  describe '#display_individual_tag' do
    it 'returns the category tag' do
      expect(helper.display_individual_tag(tag)).to have_content(tag.category)
    end

    it 'returns a link to edit tag' do
      expect(helper.display_individual_tag(tag)).to have_link('Edit')
    end

    it 'returns a link ot delete tag' do
      expect(helper.display_individual_tag(tag)).to have_link('Delete')
    end

    it 'returns a td for each element (category, link to edit, link to delete)' do
      expect(helper.display_individual_tag(tag)).to have_css('td', count: 3)
    end
  end

  describe '#display_tags' do
    context 'when current_tag is not within the tags' do
      it 'returns a table row for each tag in tags' do
        expect(helper.display_tags(tags, tag)).to have_css('tr', count: tags.count)
      end

      it 'returns the category for each tag in tags within the tr' do
        tags.each do |t|
          expect(helper.display_tags(tags, tag)).to have_content(t.category)
        end
      end
    end

    context 'when current_tag is within the tags' do
      let(:new_tags) { tags << tag }
      it 'returns a table row for each tag except from the current_tag' do
        expect(helper.display_tags(new_tags, tag)).to have_css('tr', count: new_tags.count - 1)
      end

      it 'does not return a table row for the current tag' do
        expect(helper.display_tags(new_tags, tag)).to have_no_content(tag.category)
      end
    end
  end
end