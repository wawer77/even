require 'rails_helper'

describe 'navigate' do
    before do
        @user = FactoryBot.create(:user)
        @other_user_1 = FactoryBot.create(:user)
        Friendship.create_reverse_friendships(@user.id, @other_user_1.id)
    end

    describe 'index' do       
        it 'shows list of friends' do
            login_as @user
            visit friendships_path
            expect(page).to have_content(/Friends/)
        end

        describe 'unconfirmed' do
            describe 'for invitor' do
                before do
                    login_as @user
                    visit friendships_path
                end

                it 'shows sent invitatios' do
                    expect(page).to have_content(/Invitation sent/)
                    expect(page).to have_link(:href => user_path(@other_user_1))
                end
    
                it  'shows revoke friend button' do
                    expect(page).to have_link("Revoke friend request")
                end
    
                it  'revoke friend button works' do
                    expect{click_on "Revoke friend request"}.to change(Friendship, :count).by(-2)
                end
            end

            describe 'for invited' do
                before do
                    login_as @other_user_1
                    visit friendships_path
                end
                it 'shows received invitatios' do
                    expect(page).to have_content(/Received invitations/)
                    expect(page).to have_link(:href => user_path(@user))
                end
    
                it  'shows ignore friend button' do
                    expect(page).to have_link("Ignore friend request")
                end
    
                it  'revoke friend button works' do
                    expect{click_on "Ignore friend request"}.to change(Friendship, :count).by(-2)
                end

                it 'confirm friend button exists' do
                    expect(page).to have_link("Confirm friend request")
                end

                it 'confirm friend button works' do
                    click_on "Confirm friend request"
                    expect(Friendship.last.status).to eq('confirmed')
                    expect(Friendship.second_to_last.status).to eq('confirmed')
                end
            end
        end

        describe 'confirmed' do
            before do
                Friendship.last.confirmed!
                Friendship.second_to_last.confirmed!
                login_as @user
                visit friendships_path
            end

            it 'shows friends' do
                expect(page).to have_content(/Friend/)
                expect(page).to have_link(:href => user_path(@other_user_1))
            end

            it  'shows delete friendship X button' do
                expect(page).to have_link("X")
            end

            it  'delete friend button works' do
                expect{click_on "X"}.to change(Friendship, :count).by(-2)
            end
        end





        #it 'shows friends' do
        #    visit friendships_path
        #    expect(page).to have_content(/Friends list/)
        #end
    end

end
