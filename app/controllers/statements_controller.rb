# frozen_string_literal: true
class StatementsController < ApplicationController
  def index
    @q = Statement.ransack(params[:q])
    @statements = @q.result(distinct: true)
      .order(year: :desc, month: :desc)
      .includes(:payroll, payroll: :employee)
      .page(params[:page])
  end

  def show
    statement = Statement.find_by(id: params[:id]) or not_found
    @details = StatementDetailsService.new(statement).run
    render_statement
  end

  private

  def render_statement
    respond_to do |format|
      format.html { render template: @details[:template] }
      format.pdf do
        pdf = SalaryPdf.new(@details)
        send_data pdf.render, filename: "Salary_#{@details[:name]}.pdf", type: "application/pdf"
      end
    end
  end

  def render_statement_pdf
    render(
      template: @details[:template],
      pdf: @details[:filename],
      encoding: "utf-8",
      layout: "pdf",
      orientation: "landscape"
    )
  end
end
