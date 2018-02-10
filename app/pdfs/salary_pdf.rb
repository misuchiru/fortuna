class SalaryPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  def initialize(details)
    super()
    @details = details
    line_items
    encrypt_document(:user_password => "#{@details[:id_number]}", :owner_password => "5xruby")
  end

  def line_items
    move_down 20
      data = [[
        {:content => "姓名", :align => :center},
        {:content => "#{@details[:name]}", :align => :center},
        {:content => "計算月份", :align => :center},
        {:content => "#{@details[:period]}", :align => :center},
         ]] + line_item_rows + [[
           {:content => "小計", :align => :center},
           {:content => "#{number_with_delimiter(@details[:gain])}", :align => :right},
           {:content => "小計", :align => :center},
           {:content => "#{number_with_delimiter(@details[:loss])}", :align => :right}
         ]] + [[
           {:content => "總計", :align => :center},
           {:content => "#{number_with_delimiter(@details[:total])}", :align => :right, :colspan => 3}
         ]]
      table(data,
        :header => true,
        :position => :center,
        :column_widths => [100, 100, 100, 100],
        :row_colors => ['DDDDDD', 'FFFFFF'],
        :cell_style => { :font => "app/assets/fonts/GenYoMinTW-Medium.ttf"},
      )
  end

  def line_item_rows
    @details[:details].map do |detail|
      [
        {:content => "#{detail[0].keys.first}", :align => :center},
        {:content => "#{number_with_delimiter(detail[0].values.first)}", :align => :right},
        {:content => "#{detail[1].keys.first}", :align => :center},
        {:content => "#{number_with_delimiter(detail[1].values.first)}", :align => :right}
      ]
    end
  end

end
