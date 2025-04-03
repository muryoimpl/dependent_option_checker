# frozen_string_literal: true

namespace :dependent_option_checker do
  desc 'Detect omissions of the dependent option and related definitions in the AR models'
  task check: :environment do
    data = DependentOptionChecker::Checker.new.execute

    if data.empty?
      puts 'No omission detected.'
    else
      puts 'Detected `dependent` option or omissions of has_many/has_one denifition.'
      puts

      data.each do |d|
        puts "# \e[32m#{d.model_name} (table: #{d.table_name})\e[0m"

        puts '  * dependent option omission' if d.unspecified.size.positive?
        d.unspecified.each do |relation_name|
          puts "    + \e[31m#{relation_name}\e[0m"
        end

        puts '  - has_many/has_one omission' if d.undeclared.size.positive?
        d.undeclared.each do |table_name|
          puts "    + \e[31m#{table_name}\e[0m"
        end
      end

      exit(1)
    end
  end
end
