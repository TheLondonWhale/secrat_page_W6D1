require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get new_user_path #on va sur la page de connexion
    assert_no_difference 'User.count' do #on rentre des données éronnées
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new' #on vérifie que l'on est "render" vers la même page
  end
end
