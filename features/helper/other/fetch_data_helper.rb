require 'json'

def fetch_otp_gmail
  10.times do |attempt|
    begin
      mail = Net::IMAP.new('imap.gmail.com', ssl: true)
      mail.login('email@mail.com', 'ldgs negb ovze vqxr')
      mail.select('inbox')
      otp = nil
      result = mail.search(['FROM', 'machtwatch.co.id', 'SUBJECT', 'Verify Your Account'])
      if result&.first&.is_a?(Integer)
        email_id = result.first
        raw_email = mail.fetch(email_id, 'RFC822').first&.attr['RFC822']
        msg = Mail.new(raw_email)
        if msg.multipart?
          msg.parts.each do |part|
            if part.content_type =~ /text\/plain/
              body = part.body.decoded
              match = /<p[^>]*>\s*Your verification code\s*<\/p>\s*<p[^>]*>\s*(\d{6})/i.match(body)
              if match
                otp = match.captures.first
                break
              end
            end
          end
        else
          body = msg.body.decoded
          match = /<p[^>]*>\s*Your verification code\s*<\/p>\s*<p[^>]*>\s*(\d{6})/i.match(body)
          if match
            otp = match.captures.first
          end
        end
        # Mark the message for deletion
        mail.store(email_id, "+FLAGS", [:Deleted])
        mail.expunge
      end
      mail.close
      mail.logout
      if otp
        return otp
      else
        puts "Attempt #{attempt + 1}: OTP not found, retrying..."
        sleep(10) # Wait for 10 seconds before the next attempt
      end
    rescue => e
      puts "Attempt #{attempt + 1}: Error occurred - #{e.message}, retrying..."
    end
  end
  raise StandardError, "Failed to fetch OTP from Gmail after 10 attempts"
end

# Define a method to filter out duplicates based on the specified conditions
def filter_duplicates(elements)
  # Create a hash to store counts of each element name
  name_counts = Hash.new(0)

  elements.each do |element|
    # Increment the count for each element name
    name_counts[element['name']] += 1
  end

  # Determine the primary status based on the conditions
  primary_status = nil
  elements.each do |element|
    element['steps'].each do |step|
      status = step['result']['status']
      if status == 'success'
        primary_status = 'success'
        break
      elsif status == 'failed' || status == 'undefined'
        primary_status = status unless primary_status == 'success'
      end
    end
    break if primary_status == 'success'
  end

  # Select only one of the elements with the primary status
  filtered_elements = elements.select do |element|
    primary_status.nil? || element['steps'].any? { |step| step['result']['status'] == primary_status }
  end

  filtered_elements
end
