class ReportMailer < ApplicationMailer
    def send_report(result)
      @result = result
      mail(to: "lsats-vod-support@umich.edu", subject: "VOD: automated report")
    end

  end