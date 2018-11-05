require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "reaching edit_page being logged in" do #test de l'accès à la page edit du profil
    get login_path #on se connecte
    post login_path, params: { session: { email: @user.email, password: 'password' } }
    assert_redirected_to root_path
    follow_redirect!
    assert_select "a[href=?]", user_path(@user) # on renvoie bien vers la show du profil
    get user_path(@user) #on a le lien du profil qui apparait dans la view d'accueil
    assert_select "table" #on affiche bien le tableau des informations
    assert_select "a[href=?]", edit_user_path(@user) #on trouve bien le lien vers la page d'edit.
  end

  test "reaching edit_page being logged out" do
    get logout_path #on se déconnecte
    assert_not is_logged_in? #on vérifie la déconnexion
    follow_redirect! #on revient sur la page d'acccueil
    assert_select "a[href=?]", user_path(@user), count: 0 #le lien du show est enlevé de la page
    get edit_user_path(@user) #on force le lien vers le edit sans être connecté
    assert_not flash.empty? #on vérife le message d'erreur
    assert_redirected_to login_path #on renvoie vers la page de connexion
  end

  test "reaching edit_page being logged as a different user"do
    get login_path #on se connecte
    post login_path, params: { session: { email: @user.email, password: 'password' } }
    assert_redirected_to root_path
    follow_redirect!
    assert_select "a[href=?]", user_path(@user) # on renvoie bien vers la show du profil
    get user_path(1) #on va sur une page différente de profil
    assert_select "table" #on affiche bien le tableau des informations
    assert_select "a[href=?]", edit_user_path(1) #on trouve bien le lien vers la page d'edit.
  end


  test "edit with invalid information" do # test de la redirection si les infos fournies lors de l'édition sont fausses
      get login_path #on se connecte
      post login_path, params: { session: { email: @user.email, password: 'password' } }
      get edit_user_path(@user) #on va sur la page d'édition
      patch user_path(@user), params: { user: { first_name: "  ",
                                        last_name: "  ",
                                        email: "wrong@exmaple,com"}
                                       } #on ne respecte plus les contraintes
      assert_not flash.empty? #on vérifie que l'on a un message d'erreur présent
      get root_path #on change de page
      assert flash.empty? #on vérifie que le message d'erreur n'apparaît qu'une fois
  end

end
