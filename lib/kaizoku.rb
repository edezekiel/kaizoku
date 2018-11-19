require "kaizoku/version"

module Kaizoku
  # Your code goes here...
  class CommandLineInterface

    def exit_screen
      puts "Thank you for using Kaizoku!"
      separator
      exit
    end

    def unrecognized_input
      puts "Input not recognized."
      exit_screen
    end


    def greeting_screen
      separator
      puts "Welcome to #{pastel.bright_yellow('Kaizoku')}!"
      puts "                                                      "
      puts "Easily find the best gem for the task at hand."
      puts "Type #{pastel.bright_yellow('list')} to see a list of gem categories."
      separator
      get_category_screen
    end

    def get_category_screen
      get_category_validation
    end

    def get_category_validation
      input = gets.chomp
      separator
      if input == "list"
        get_category
      elsif input == "exit"
        exit_screen
      else
        unrecognized_input
      end
    end

    def get_category
      doc = Nokogiri::HTML(open("https://www.ruby-toolbox.com"))
      doc.css(".category-group").each do |category|
        puts category.css("h3").text
      end
      get_subcategory_screen
    end


    def get_subcategory_screen
      separator
      puts "Please make a selection:"
      puts "  "
      puts "#{pastel.bright_yellow('[category]')} - enter one of the categories see gem subcategories."
      puts "#{pastel.bright_yellow('back')} - go back to the main screen."
      puts "#{pastel.bright_yellow('exit')} - go quit the app."
      separator
      input = gets.chomp
      if input == "exit"
        exit_screen
      elsif input == "back"
        greeting_screen
      else
        get_subcategory(input)
      end
    end

    def get_subcategory(input)
      separator
      doc = Nokogiri::HTML(open("https://www.ruby-toolbox.com"))
      doc.css(".category-group").each do |category|
        category.css(".column.is-half-desktop").each do |subcategory|
          if category.css("h3").text == input
            @category = category
            @subcategory = subcategory
            puts "Here are the #{pastel.bright_yellow('subcategories')}, if any:"
            puts "  "
            puts subcategory.css("a span").text
            get_gem_screen
          end
        end
      end
    end


    def get_gem_screen
      separator
      puts "Type the subcategory to see the best gem for that category."
      puts "#{pastel.bright_yellow('back')} - go back to the main screen."
      puts "#{pastel.bright_yellow('exit')} - go quit the app."
      separator
      input = gets.chomp
      separator
      if input == "exit"
        exit_screen
      elsif input == "back"
        greeting_screen
      else
        doc = gem_description(input)
        gem_description_output(doc)
      end

    end

    def gem_description(input)
      url = "https://www.ruby-toolbox.com" + @subcategory.css("a").attribute("href").value
      doc = Nokogiri::HTML(open(url))
      doc
    end

    def gem_description_output(doc)
      puts "Here's the gem for the job!"
      puts "  "
      puts "#{pastel.bright_yellow(doc.css(".is-size-4").first.children.text)}"
      puts "  "
      puts "#{pastel.bright_yellow('score: ')} " + doc.css(".score").first.css("span").text
      puts "#{pastel.bright_yellow('description: ')} " + doc.css(".description.column").first.text
      puts "#{pastel.bright_yellow('github: ')}: " + doc.css(".links.column").first.css(".button.is-white")[1].attributes["href"].text
      separator
      exit_screen
    end

    def pastel
      pastel = Pastel.new
      pastel
    end

    def separator
      pastel
      puts "                                                      "
      puts pastel.bright_yellow("======================================================")
      puts "                                                      "
    end

    def run
      greeting_screen
    end
  end
end
