# app/controllers/jobs_controller.rb
class JobsController < ApplicationController
  include ActionView::Helpers::NumberHelper
  require 'csv'
  before_action :authenticate_user!
  before_action :set_job, only: %i[show edit update destroy export_pdf export_excel export_csv]

  def index
    @jobs = current_user.accessible_jobs
  end

  def show
  end

  def new
    @job = Job.new
    @services = current_user.accessible_services
  end

  def edit
    @services = current_user.accessible_services
  end

  def create
    @job = current_user.jobs.build(job_params)
    @job.added_by = current_user  # Add this line
    @job.last_modified_by = current_user  # Add this line too
      
    if @job.save
      save_services_with_quantities
      redirect_to jobs_path, notice: 'Job was successfully created.'
    else
      @services = current_user.accessible_services
      render :new, status: :unprocessable_entity
    end
  end
  
  def update
    @job.last_modified_by = current_user  # Add this line
    
    if @job.update(job_params)
      save_services_with_quantities
      redirect_to jobs_path, notice: 'Job was successfully updated.'
    else
      @services = current_user.accessible_services
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @job.job_services.destroy_all
    @job.destroy
    redirect_to jobs_path, notice: 'Job was successfully deleted.'
  end

  def export_pdf
    pdf = Prawn::Document.new(margin: 50)
    
    customer_info = "Invoice ##{@job.id}"
    customer_info += " - #{@job.customer_name}"
    pdf.text customer_info, size: 24, style: :bold
    pdf.text "Date: #{@job.date.strftime('%B %d, %Y')}"
    pdf.move_down 20

    pdf.text "Bill To:"
    pdf.text @job.customer_name
    if @job.phone_number.present?
      pdf.text "Phone: #{@job.phone_number}"
    end
    if @job.address.present?
      pdf.text "Address: #{@job.address}"
    end
    pdf.move_down 20

    items = @job.job_services.select { |js| js.quantity > 0 }.map do |job_service|
      [
        job_service.service.name,
        job_service.quantity,
        number_to_currency(job_service.service.price),
        number_to_currency(job_service.service.price * job_service.quantity)
      ]
    end

    pdf.table([['Service', 'Quantity', 'Price', 'Total']] + items) do |table|
      table.row(0).background_color = 'CCCCCC'
      table.row(0).font_style = :bold
      table.columns(2..3).align = :right
      table.width = pdf.bounds.width
      table.cell_style = { 
        padding: [12, 6, 12, 6],
        borders: [:top, :bottom, :left, :right]
      }
    end

    pdf.move_down 20
    pdf.text "Total Amount Due: #{number_to_currency(@job.total_price)}", 
      style: :bold,
      align: :right,
      size: 12

    pdf.move_down 40
    pdf.text "Thank you for your business!", 
      align: :center,
      size: 12

    filename_parts = ["Invoice"]
    filename_parts << @job.customer_name.gsub(/\s+/, '_')
    filename_parts << @job.phone_number.gsub(/\D/, '') if @job.phone_number.present?
    filename_parts << @job.id.to_s

    send_data pdf.render,
      filename: "#{filename_parts.join('_')}.pdf",
      type: 'application/pdf',
      disposition: 'attachment'
  end

  def export_excel
    p = Axlsx::Package.new
    wb = p.workbook

    wb.add_worksheet(name: "Invoice #{@job.id}") do |sheet|
      title = "Invoice ##{@job.id} - #{@job.customer_name}"
      title += " - #{@job.phone_number}" if @job.phone_number.present?
      
      sheet.add_row [title], style: wb.styles.add_style(b: true, sz: 16)
      sheet.add_row ["Date: #{@job.date.strftime('%B %d, %Y')}"]
      sheet.add_row []
      
      sheet.add_row ["Bill To:"], style: wb.styles.add_style(b: true)
      sheet.add_row ["Customer:", @job.customer_name]
      sheet.add_row ["Phone:", @job.phone_number] if @job.phone_number.present?
      sheet.add_row ["Address:", @job.address] if @job.address.present?
      sheet.add_row []
      
      headers = ['Service', 'Quantity', 'Price', 'Total']
      sheet.add_row headers, style: wb.styles.add_style(b: true, bg_color: "CCCCCC")
      
      @job.job_services.select { |js| js.quantity > 0 }.each do |job_service|
        sheet.add_row [
          job_service.service.name,
          job_service.quantity,
          job_service.service.price,
          job_service.service.price * job_service.quantity
        ]
      end
      
      sheet.add_row []
      sheet.add_row ['Total Amount Due:', '', '', @job.total_price], 
        style: wb.styles.add_style(b: true)
      
      sheet.add_row []
      sheet.add_row ["Thank you for your business!"]
    end

    filename = ["Invoice"]
    filename << @job.customer_name.gsub(/\s+/, '_')
    filename << @job.phone_number.gsub(/\D/, '') if @job.phone_number.present?
    filename << @job.id.to_s

    send_data p.to_stream.read,
      filename: "#{filename.join('_')}.xlsx",
      type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      disposition: 'attachment'
  end

  def export_csv
    csv_data = CSV.generate do |csv|
      header = "Invoice ##{@job.id} - #{@job.customer_name}"
      header += " - #{@job.phone_number}" if @job.phone_number.present?
      csv << [header]
      csv << ["Date: #{@job.date.strftime('%B %d, %Y')}"]
      csv << []
      
      csv << ["Bill To:"]
      csv << ["Customer:", @job.customer_name]
      csv << ["Phone:", @job.phone_number] if @job.phone_number.present?
      csv << ["Address:", @job.address] if @job.address.present?
      csv << []
      
      csv << ['Service', 'Quantity', 'Price', 'Total']
      
      @job.job_services.select { |js| js.quantity > 0 }.each do |job_service|
        csv << [
          job_service.service.name,
          job_service.quantity,
          job_service.service.price,
          job_service.service.price * job_service.quantity
        ]
      end

      csv << []
      csv << ['Total Amount Due:', '', '', @job.total_price]
      csv << []
      csv << ["Thank you for your business!"]
    end

    filename = ["Invoice"]
    filename << @job.customer_name.gsub(/\s+/, '_')
    filename << @job.phone_number.gsub(/\D/, '') if @job.phone_number.present?
    filename << @job.id.to_s

    send_data csv_data,
      filename: "#{filename.join('_')}.csv",
      type: 'text/csv',
      disposition: 'attachment'
  end

  private
    def set_job
      @job = current_user.accessible_jobs.find(params[:id])
    end

    def job_params
      params.require(:job).permit(:customer_name, :date, :status, :address, :phone_number, :notes)
    end

    def save_services_with_quantities
      return unless params[:service_ids]
      
      # Clear existing job services first
      @job.job_services.destroy_all
      
      # Only create job services for selected services
      params[:service_ids].each do |service_id|
        quantity = (params[:quantities] || {})[service_id].to_i
        quantity = 1 if quantity == 0
        
        JobService.create!(
          job: @job,
          service_id: service_id,
          quantity: quantity
        )
      end
    rescue StandardError => e
      Rails.logger.error "Failed to save services: #{e.message}"
    end
end