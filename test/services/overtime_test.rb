# frozen_string_literal: true
require "test_helper"

class OvertimeTest < ActiveSupport::TestCase
  def salary
    build(:salary, monthly_wage: 36000)
  end

  def test_weekday_initial_rate
    obj = OvertimeService.new(1, salary)
    assert_equal obj.weekday, 200
  end

  def test_weekday_additional_rate
    obj = OvertimeService.new(3, salary)
    assert_equal obj.weekday, (200 * 2 + 250)
  end

  def test_weekend_initial_rate
    obj = OvertimeService.new(1, salary)
    assert_equal obj.weekend, 200
  end

  def test_weekend_additional_rate
    obj = OvertimeService.new(3, salary)
    assert_equal obj.weekend, (200 * 2 + 250)
  end

  def test_weekend_final_rate
    obj = OvertimeService.new(10, salary)
    assert_equal obj.weekend, (200 * 2 + 250 * 6 + 400 * 2)
  end

  def test_holiday_rate
    obj = OvertimeService.new(nil, salary)
    assert_equal obj.holiday, (150 * 8 * 2)
  end

  def test_basic_rate
    obj = OvertimeService.new(5, salary)
    assert_equal obj.basic, (150 * 5)
  end
end
