require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "login with invalid information" do # test la redirection si les infos fournies lors de la connexion sont fausses
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information" do #test avec les bonnes infos en page et en navbar
  get login_path
  post login_path, params: { session: { email:    @user.email,
                                        password: 'password' } }
  assert_redirected_to root_path # on redirige bien vers la page d'accueil
  follow_redirect!
  assert_template 'static_page/home'
  assert_select "a[href=?]", login_path, count: 0 # on a bien enlevé le bouton de connexion
  assert_select "a[href=?]", logout_path # on a bien ajouté le bouton de deconnexion
  assert_select "a[href=?]", users_path # on a bien le lien vers la page secrète
  assert_select "a[href=?]", user_path(@user) # on renvoie bien vers la show du profil
  get logout_path # on test la deconnexion
  assert_not is_logged_in? #on est bien déconnecté
  assert_redirected_to root_url
  follow_redirect! #retour à l apage d'accueil
  assert_select "a[href=?]", user_path(@user), count: 0 # on a plus le lien vers la show du user
  assert_select "a[href=?]", login_path # on retrouve bien le bouton de connexion
  assert_select "a[href=?]", logout_path,      count: 0 # on a plus  le bouton de deconnexion
  assert_select "a[href=?]", users_path, count: 0 # on a plus le lien vers la secret page
  end

end
