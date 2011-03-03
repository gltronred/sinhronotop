module UnitTestHelper

  def check_email(to_arr, arr_contains, arr_not_contains=[])
    assert !ActionMailer::Base.deliveries.empty?
    mail = ActionMailer::Base.deliveries.last
    to_arr.each {|to|assert mail.to.include?(to)}
    arr_contains.each do |cont|
      assert mail.body.include?(cont), "phrase '#{cont}' not found in #{mail.body}"
    end
    arr_not_contains.each do |ncont|
      assert !mail.body.include?(ncont), "phrase '#{ncont}' found in #{mail.body}"
    end
  end

  URL_REGEXP = /https?:\/\/[\S]+/

  def get_url_from_last_email
    assert !ActionMailer::Base.deliveries.empty?
    mail = ActionMailer::Base.deliveries.last
    urls = mail.body.scan URL_REGEXP
    urls.empty? ? nil : urls.first
  end
end
