# frozen_string_literal: true

class ProcessingLogsController < ApplicationController
  def index
    @logs = ProcessingLog.includes(:customer)
                        .order(created_at: :desc)
                        .page(params[:page])
                        .per(20)
    
    @stats = {
      total: ProcessingLog.count,
      successful: ProcessingLog.successful.count,
      failed: ProcessingLog.failed.count
    }
  end

  def show
    @log = ProcessingLog.find(params[:id])
  end
end
