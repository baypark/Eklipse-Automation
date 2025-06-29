module CommandHelper
  def self.generate_commands(tags_to_run)
    tags_to_run.map do |tag|
      "cucumber --tags \"#{tag}\" --retry 1 --no-strict-flaky -f rerun --out rerun.txt"
    end
  end

  def self.run_commands_in_parallel(commands, tags_to_run, report_dir, formatted_time)
    Parallel.each_with_index(commands, in_processes: commands.length) do |cmd, index|
      if ENV['SHUFFLE_BROWSER'] == 'true'
        ENV['BROWSER'] = index.even? ? 'firefox' : 'chrome'
      end
      feature_tags = substring(tags_to_run[index])
      json_file = "#{report_dir}/json/thread_#{index + 1}.json"
      system("#{cmd} -f pretty -f json -o #{json_file}")
    end
  end

  def self.substring(string)
    arr = string.gsub(".", "-").split(" ")
    platform = arr[0].gsub("@", "")
    feature = arr[2].gsub("@", "")
    "#{platform}_#{feature}"
  end
end
