require 'open-uri'

class Trice
  #match /^(.+)[\?]$/, sent_to_me: true do |matchers, message|
  def ask_question(string)
    question = URI.encode(string)
    url = "https://answers.yahoo.com/search/search_result?fr=uh3_answers_vert_gs&type=2button&p=#{question}"
    agent = Mechanize.new
    page = agent.get(url)
    random_question_link = page.search(".question-title").css("a").to_a.sample

    if random_question_link.nil?
      failed_response
    else
      question_uri = random_question_link.attr("href")
      question_link = "https://answers.yahoo.com#{question_uri}"
      get_random_yahoo_answer(question_link)
    end
  end

  def get_random_yahoo_answer(link)
    question_page = Nokogiri::HTML(open(link))
    #answers = question_page.css("div.content").to_a.drop(1)
    answers = question_page.css("span.ya-q-full-text").to_a

    if answers.empty?
      failed_response
    else
      random_answer_response = answers.sample.text
      puts random_answer_response
    end
  end

  def failed_response
    puts "Sorry, I couldn't find anything."
  end

  def eightball_answers
    ["It is certain.",
     "It is decidedly so.",
     "Without a doubt.",
     "Yes definitely.",
     "You may rely on it.",
     "As I see it, yes.",
     "Most likely.",
     "Outlook good.",
     "Yes.",
     "Signs point to yes.",
     "Reply hazy try again.",
     "Ask again later.",
     "Better not tell you now.",
     "Cannot predict now.",
     "Concentrate and ask again.",
     "Don't count on it.",
     "My reply is no.",
     "My sources say no.",
     "Outlook not so good.",
     "Very doubtful."]
  end
end

trice = Trice.new
puts "Ask me a question:"
puts "> "
question = gets.chomp
trice.ask_question(question)
