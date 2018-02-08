class SalaryPdf < Prawn::Document
  def initialize(details)
    super()
    @details = details
    quotation_title
    company_info
    line_items
  end

  def salary_title
    font("app/assets/fonts/GenYoMinTW-Bold.ttf") do
      text "<u>估   價   單</u>", size: 20, align: :center, :inline_format => true
      move_down 30
    end
  end

  def company_info
    font("app/assets/fonts/GenYoMinTW-Medium.ttf", :size => 12) do
      text "客戶名稱：#{@quotation.company.title}"
      move_down 10
      text "電        話：#{@quotation.company.telephone}"
      move_down 10
      text "地        址：#{@quotation.company.address}"
    end
  end

  def line_items
    move_down 20
      data = [[
        {:content => "編號", :align => :center},
        {:content => "工程項目", :align => :center},
        {:content => "數量", :align => :center},
        {:content => "單價", :align => :center},
        {:content => "金額", :align => :center}
         ]] + line_item_rows + [[{:content => "總計金額", :colspan => 4}, {:content => "NT$ #{@quotation.total_price} 元", :align => :right}]]
      table(data,
        :header => true,
        :position => :center,
        :column_widths => [40, 220, 55, 100, 120],
        :row_colors => ['DDDDDD', 'FFFFFF'],
        :cell_style => { :font => "app/assets/fonts/GenYoMinTW-Medium.ttf"},
      )
  end

  def line_item_rows
    @items.each_with_index.map do |item,index|
      [{:content => "#{index + 1}", :align => :center}, item.title, {:content => "#{item.amount}", :align => :center}, {:content => "#{item.price} 元", :align => :right}, {:content => "#{item.price * item.amount} 元", :align => :right}]
    end
  end

end
