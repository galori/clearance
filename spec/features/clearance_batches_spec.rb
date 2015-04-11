require "rails_helper"

describe "add new monthly clearance_batch" do

  describe "clearance_batches index", type: :feature do

    describe "when previous batches exist", :js => true do

      let!(:clearance_batch_1) { create(:clearance_batch) }
      let!(:clearance_batch_2) { create(:clearance_batch) }

      let!(:dress_style) { create(:style, :type => 'Dress', :name => 'Collegno Diamond Print Drawstring Waist Dress') }
      let!(:pants_style) { create(:style, :type => 'Pants', :name => 'Blue Camo Print Boyfriend Jeans') }

      let!(:dress_item) { create(:item, :clearance_batch => clearance_batch_1, :style => dress_style, :color => 'Navy', :price_sold => 33.00)}
      let!(:pants_item) { create(:item, :clearance_batch => clearance_batch_1, :style => pants_style, :color => 'Blue', :price_sold => 81.00)}

      it "displays a list of all past clearance batches" do
        visit "/"
        expect(page).to have_content("Stitch Fix Clearance Tool")
        expect(page).to have_content("Clearance Batches")
        within('table#batches-table') do
          expect(page).to have_content("Clearance Batch #{clearance_batch_1.id}")
          expect(page).to have_content("Clearance Batch #{clearance_batch_2.id}")
        end
      end

      it "allow clicking on a batch to see the items in it" do
        visit "/"
        find("tr#batch-#{clearance_batch_1.id}").click()

        expect(page).to have_content("Clearance Batch #{clearance_batch_1.id} Items")

        within "tr#item-#{dress_item.id}" do
          expect(page).to have_content('Collegno Diamond Print Drawstring Waist Dress')
          expect(page).to have_content('Dress')
          expect(page).to have_content('Navy')
          expect(page).to have_content('$33.00')
        end

        within "tr#item-#{pants_item.id}" do
          expect(page).to have_content('Blue Camo Print Boyfriend Jeans')
          expect(page).to have_content('Pants')
          expect(page).to have_content('Blue')
          expect(page).to have_content('$81.00')
        end

      end

    end

    describe "add a new clearance batch" do

      context "total success" do

        it "should allow a user to upload a new clearance batch successfully" do
          items = 5.times.map{ create(:item) }
          file_name = generate_csv_file(items)
          visit "/"
          within('table#batches-table') do
            expect(page).not_to have_content(/Clearance Batch \d+/)
          end
          attach_file("Select batch file", file_name)
          click_button "upload batch file"
          new_batch = ClearanceBatch.first
          expect(page).to have_content("#{items.count} items clearanced in batch #{new_batch.id}")
          expect(page).not_to have_content("item ids raised errors and were not clearanced")
          within('table#batches-table') do
            expect(page).to have_content(/Clearance Batch \d+/)
          end
        end

      end

      context "partial success" do

        it "should allow a user to upload a new clearance batch partially successfully, and report on errors" do
          valid_items   = 3.times.map{ create(:item) }
          invalid_items = [[987654], ['no thanks']]
          file_name     = generate_csv_file(valid_items + invalid_items)
          visit "/"
          within('table#batches-table') do
            expect(page).not_to have_content(/Clearance Batch \d+/)
          end
          attach_file("Select batch file", file_name)
          click_button "upload batch file"
          new_batch = ClearanceBatch.first
          expect(page).to have_content("#{valid_items.count} items clearanced in batch #{new_batch.id}")
          expect(page).to have_content("#{invalid_items.count} item ids raised errors and were not clearanced")
          within('table#batches-table') do
            expect(page).to have_content(/Clearance Batch \d+/)
          end
        end

      end

      context "total failure" do

        it "should allow a user to upload a new clearance batch that totally fails to be clearanced" do
          invalid_items = [[987654], ['no thanks']]
          file_name     = generate_csv_file(invalid_items)
          visit "/"
          within('table#batches-table') do
            expect(page).not_to have_content(/Clearance Batch \d+/)
          end
          attach_file("Select batch file", file_name)
          click_button "upload batch file"
          expect(page).not_to have_content("items clearanced in batch")
          expect(page).to have_content("No new clearance batch was added")
          expect(page).to have_content("#{invalid_items.count} item ids raised errors and were not clearanced")
          within('table#batches-table') do
            expect(page).not_to have_content(/Clearance Batch \d+/)
          end
        end
      end
    end
  end
end

