class ReportMailer < ApplicationMailer
    default from: 'VOD <vod-users-devs@umich.edu>'
  
    def send_report(result)
      @result = result
      mail(to: "brita@umich.edu", subject: "VOD: automated report")
    end

  end