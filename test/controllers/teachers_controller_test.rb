require 'test_helper'

class TeachersControllerTest < ActionDispatch::IntegrationTest
  setup { @teacher = teachers(:one) }

  test 'should get index' do
    get teachers_url
    assert_response :success
  end

  test 'should get new' do
    get new_teacher_url
    assert_response :success
  end

  test 'should create teacher' do
    assert_difference('Teacher.count') do
      post teachers_url,
           params: { teacher: { name: @teacher.name, status: @teacher.status } }
    end

    assert_redirected_to teacher_url(Teacher.last)
  end

  test 'should show teacher' do
    get teacher_url(@teacher)
    assert_response :success
  end

  test 'should get edit' do
    get edit_teacher_url(@teacher)
    assert_response :success
  end

  test 'should update teacher' do
    patch teacher_url(@teacher),
          params: { teacher: { name: @teacher.name, status: @teacher.status } }
    assert_redirected_to teacher_url(@teacher)
  end

  test 'should destroy teacher' do
    assert_difference('Teacher.count', -1) { delete teacher_url(@teacher) }

    assert_redirected_to teachers_url
  end
end
