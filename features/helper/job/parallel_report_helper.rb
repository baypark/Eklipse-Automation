require 'slack-ruby-client'

module ReportHelper
  def self.send_slack_reports(html_files, blocks)
    chart_datas
    format = Time.now.to_i[0..11]
    client = Slack::Web::Client.new
    client.auth_test

    files = client.files_upload(
      file: Faraday::UploadIO.new(html_files + '.html', 'text/html'),
      title: "ReportBuilder_#{format}.html",
      filename: "cucumber_#{format}.html",
    )
    client.chat_postMessage(
      channel: "#{ENV['SLACK_CHANNEL']}",
      text: files["file"]["permalink"],
      blocks: blocks,
      as_user: true
    )
  end

  def self.chart_datas
    chart = QuickChart.new(
      {
        type: 'doughnut',
        data: {
          datasets: [
            {
              data: [$percent_passed, $percent_failed],
              backgroundColor: ['#009944', '#D82C2C'],
              borderWidth: 0,
            }
          ],
        },
        options: {
          centerPercentage: 70,
          plugins: {
            datalabels: {
              display: false,
            },
            doughnutlabel: {
              labels: [
                {
                  text: "#{$percent_passed}%",
                  color: '#009944',
                  font: {
                    size: 50,
                    weight: 'bold',
                  },
                },
              ],
            },
          },
        },
      },
      background_color: '#00000000',
    )
  end

  def self.slack_messages(feature)
    messages = [
      {
        type: "header",
        text: {
          type: "plain_text",
          text: ":bangbang: AUTOMATION RESULT :bangbang:",
          emoji: true
        }
      },
      {
        type: "section",
        text: {
          type: "mrkdwn",
          text: "*Overview:*\n>*Tags:* `#{feature}`\n>*Date:* `#{Time.now.strftime("%d %B %Y")}`\n>*Domain:* `Automation POS JT `\n>*Browser:* `#{ENV['BROWSER'].capitalize}`\n>*Environment:* `#{ENV['TARGET'].capitalize}`\n>*Total Feature:* `#{$feature_count}`\n>*Total Scenario:* `#{$scenario_count}`\n>*Success:* `#{$passed} (#{$percent_passed}%)` :white_check_mark:\n>*Failed:* `#{$failed} (#{$percent_failed}%)` :x:\n>*Duration:* `#{$duration}`
                \nYou can click button below or download the attachment html file to see more detail, cc: <!channel>"
        },
        accessory: {
          type: "image",
          image_url: "#{chart_data.get_short_url}",
          alt_text: "Success: #{$passed} (#{$percent_passed}%), Failed: #{$failed} (#{$percent_failed}%)"
        }
      }
    ]
  end
end
