require 'test_helper'

class CreateCategoriesTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = User.create(username: "john", email: "john@example.com", password: "password", admin: true)
  end
  
  test 'get new category form and create category' do
    sign_in_as(@user, "password")
    #Going to a new category path
    get new_category_path
    #Getting a new category for,
    assert_template 'categories/new'
    # Posting to the new form with the name sports
    assert_difference 'Category.count', 1 do
      post_via_redirect categories_path, category: {name: "sports"}
    end
    #It should  show sports in the categories index
    assert_template 'categories/index'
    assert_match "sports", response.body
  end
  
  test "invalid category submission results in failure" do
    sign_in_as(@user, "password")
     #Going to a new category path
    get new_category_path
    #Getting a new category for,
    assert_template 'categories/new'
    assert_no_difference 'Category.count' do
      post categories_path, category: {name: " "}
    end
    
    assert_template 'categories/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
  
end