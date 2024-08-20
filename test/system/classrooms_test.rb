require 'application_system_test_case'

class ClassroomsTest < ApplicationSystemTestCase
  setup { @classroom = classrooms(:one) }

  test 'visiting the index' do
    visit classrooms_url
    assert_selector 'h1', text: 'Classrooms'
  end

  test 'should create classroom' do
    visit classrooms_url
    click_on 'New classroom'

    fill_in 'Name', with: @classroom.name
    fill_in 'Teacher', with: @classroom.teacher_id
    fill_in 'Time', with: @classroom.time
    click_on 'Create Classroom'

    assert_text 'Classroom was successfully created'
    click_on 'Back'
  end

  test 'should update Classroom' do
    visit classroom_url(@classroom)
    click_on 'Edit this classroom', match: :first

    fill_in 'Name', with: @classroom.name
    fill_in 'Teacher', with: @classroom.teacher_id
    fill_in 'Time', with: @classroom.time
    click_on 'Update Classroom'

    assert_text 'Classroom was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Classroom' do
    visit classroom_url(@classroom)
    click_on 'Destroy this classroom', match: :first

    assert_text 'Classroom was successfully destroyed'
  end
end
