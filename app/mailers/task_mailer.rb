class TaskMailer < ApplicationMailer

  def performance_issues_tracking(rows_need)
    @rows = rows_need
    mail(to: 'stas.t@zone3000.net', subject: "Checkout and Website Performance Issues Tracking - #{Date.today.strftime('%d %b')}")
  end
end