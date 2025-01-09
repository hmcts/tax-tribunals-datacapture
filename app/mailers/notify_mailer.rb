class NotifyMailer < GovukNotifyRails::Mailer
  rescue_from Exception, with: :log_errors


  def test_delayed_job
    set_template('01a8ef67-1bf7-4b91-b153-17868df2afe4')
    mail(to: 'petr.zaparka@hmcts.net')
  end

end
