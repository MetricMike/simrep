require 'google_drive'

class DumpBankAccountJob < ApplicationJob
  queue_as :default

  def perform(bank_account, online=false)
    # localhost = `getent hosts app | awk '{ print $1 ; exit }'`.strip
    filename = "#{bank_account.display_name}_#{Date.current.to_formatted_s(:iso8601)}".parameterize + ".pdf"
    command = "curl '$ATHENA_CONTAINER_URL/convert\?auth\=arachnys-weaver\&url\=http://web_{Rails.env}/bank_accounts/#{bank_account.id}/print'"

    pdf_stream = StringIO.new(`#{command}`)
    raise AthenaConversionError if pdf_stream.length < 1000

    current_chapter = bank_account.chapter.name

    filepath = File.join(Rails.root, 'pdfs', Event.last.weekend, 'bank_accounts', current_chapter, filename)
    File.open(filepath, 'wb') { |f| f.write(pdf_stream) }

    if online
      session = GoogleDrive::Session.from_service_account_key('config/simrep-google-serviceaccount.json')
      dump_folder = session.collection_by_url(ENV['DUMP_FOLDER_URL'])
        .subcollection_by_title('Bank Accounts')
        .subcollection_by_title(current_chapter)

      dump_folder.upload_from_io(pdf_stream, filename)
  end
end
end
