require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    students_scraped = doc.css(".student-card")

    students_array = []

    students_scraped.each do |student|
      student_hash = Hash.new
      student_hash[:name] = student.css("h4.student-name").text
      student_hash[:location] = student.css("p.student-location").text
      student_hash[:profile_url] = student.css("a").attribute("href").value
      students_array << student_hash
    end
    students_array
  end

  def self.scrape_profile_page(profile_url)
    scrape = Nokogiri::HTML(open(profile_url))
    profile_links = scrape.css(".social-icon-container a")

    profile_hash = Hash.new

    profile_links.each do |profile_link|
      if profile_link.attribute("href").value.include?("twitter")
        profile_hash[:twitter] = profile_link.attribute("href").value
      elsif profile_link.attribute("href").value.include?("linkedin")
        profile_hash[:linkedin] = profile_link.attribute("href").value
      elsif profile_link.attribute("href").value.include?("github")
        profile_hash[:github] = profile_link.attribute("href").value
      else
        profile_hash[:blog] = profile_link.attribute("href").value
      end
    end

    profile_hash[:profile_quote] = scrape.css(".profile-quote").text
    profile_hash[:bio] = scrape.css(".bio-content.content-holder .description-holder p").text

    profile_hash
  end

end
