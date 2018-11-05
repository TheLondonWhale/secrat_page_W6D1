require 'test_helper'

class UsersReachingPrivatePageTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "reaching secret_page being logged in" do #test de la page secrète
    get login_path #on se connecte
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert_redirected_to root_path
    get users_path #on atteint bien la pae secrète
    assert_select "table" #on affiche bien le tableau des users
    get logout_path #on se déconnecte
    assert_not is_logged_in?
    get users_path #on essaie d'atteindre la page secrète
    assert_not flash.empty? #on vérife que l'on obtinet un message d'erreur
    assert_redirected_to login_path #on est redirigé vers la page de connexion
  end

end
