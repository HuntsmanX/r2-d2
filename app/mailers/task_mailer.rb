class TaskMailer < ApplicationMailer

  def performance_issues_tracking(row)
    @timestamp = row[0]
    @who_affected = row[3]
    @what_affected = row[4]
    @issue_type = row[5]
    @reference = row[6]
    @description = row[7]
    mail(to: 'stas.t@zone3000.net', subject: "Checkout and Website Performance Issues Tracking - #{Date.strptime(@timestamp, "%m/%d/%Y").to_date.strftime('%d %b %Y')}")
  end
end